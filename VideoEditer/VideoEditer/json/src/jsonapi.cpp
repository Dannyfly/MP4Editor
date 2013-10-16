//#include "stdafx.h"
#include "jsonapi.h"
#include "json/json.h"
#include <iostream>
#include <sstream>
#include <algorithm> // sort

#pragma warning( disable : 4996 )   // disable warning about strdup being deprecated.

Jsonapi::Jsonapi()
{
}

Jsonapi::~Jsonapi()
{
}

void Jsonapi::Parse(const std::string &input, Json::Value &root)
{
	Json::Reader reader;
	reader.parse(input, root);
}

void Jsonapi::Store(Json::Value &root, std::string &out)
{
	Json::StyledWriter fast_writer;

	out.append(fast_writer.write(root).c_str());
}

std::string Jsonapi::normalizeFloatingPointStr( double value )
{
	char buffer[32];
	sprintf( buffer, "%.16g", value );
	buffer[sizeof(buffer)-1] = 0;
	std::string s( buffer );
	std::string::size_type index = s.find_last_of( "eE" );
	if ( index != std::string::npos )
	{
		std::string::size_type hasSign = (s[index+1] == '+' || s[index+1] == '-') ? 1 : 0;
		std::string::size_type exponentStartIndex = index + 1 + hasSign;
		std::string normalized = s.substr( 0, exponentStartIndex );
		std::string::size_type indexDigit = s.find_first_not_of( '0', exponentStartIndex );
		std::string exponent = "0";
		if ( indexDigit != std::string::npos ) // There is an exponent different from 0
		{
			exponent = s.substr( indexDigit );
		}
		return normalized + exponent;
	}
	return s;
}

void Jsonapi::Store(Json::Value &value, std::string &out, const std::string &path)
{
	switch ( value.type() )
	{
	case Json::nullValue:
		out.append("%s=null\n", path.c_str() );
		break;
	case Json::intValue:
		{
			ostringstream os;
			os << path.c_str() << "=" << Json::valueToString( value.asLargestInt() ).c_str() << "\n";
			out += os.str();
		}
		break;
	case Json::uintValue:
		{
			ostringstream os;
			os << path.c_str() << "=" << Json::valueToString( value.asLargestUInt() ).c_str() << "\n";
			out += os.str();
		//out.append("%s=%s\n", path.c_str(), Json::valueToString( value.asLargestUInt() ).c_str() );
		}
		break;
	case Json::realValue:
		{
			ostringstream os;
			os << path.c_str() << "=" << this->normalizeFloatingPointStr(value.asDouble()).c_str() << "\n";
			out += os.str();
			//out.append("%s=%s\n", path.c_str(), normalizeFloatingPointStr(value.asDouble()).c_str() );
		}
		break;
	case Json::stringValue:
		{
			ostringstream os;
			os << path.c_str() << "=" << value.asString().c_str() << "\n";
			out += os.str();
		}
		break;
	case Json::booleanValue:
		{
			ostringstream os;
			os << path.c_str() << "=" << (value.asBool() ? "true" : "false") << "\n";
			out += os.str();
		}
		//out.append("%s=%s\n", path.c_str(), value.asBool() ? "true" : "false" );
		break;
	case Json::arrayValue:
		{
			ostringstream os;
			os << path.c_str() << "=[]\n";
			//out.append("%s=[]\n", path.c_str() );
			out += os.str();
			int size = value.size();
			for ( int index =0; index < size; ++index )
			{
				static char buffer[16];
				sprintf( buffer, "[%d]", index );
				this->Store(value[index], out, path + buffer );
			}
		}
		break;
	case Json::objectValue:
		{
			ostringstream os;
			os << path.c_str() << "={}\n";
			out += os.str();
			//out.append("%s={}\n", path.c_str() );
			Json::Value::Members members( value.getMemberNames() );
			std::sort( members.begin(), members.end() );
			std::string suffix = *(path.end()-1) == '.' ? "" : ".";
			for ( Json::Value::Members::iterator it = members.begin(); 
				it != members.end(); 
				++it )
			{
				const std::string &name = *it;
				this->Store(value[name], out, path + suffix + name );
			}
		}
		break;
	default:
		break;
	}
}
