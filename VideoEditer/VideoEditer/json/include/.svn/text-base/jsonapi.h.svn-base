#ifndef _JSONAPI_H__
#define _JSONAPI_H__

#include <vector>
#include "json.h"
using namespace std;

class Jsonapi
{
public:
	Jsonapi();
	virtual ~Jsonapi();

public:
	void Parse(const std::string &input, Json::Value &root);
	void Store(Json::Value &root, std::string &out);

private:
	void Store(Json::Value &value, std::string &out, const std::string &path);
	std::string normalizeFloatingPointStr( double value);
};

#endif
