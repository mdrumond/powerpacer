
app_name = TrimpPerHour
devkey := developer_key.der
manifest := manifest.xml
resource_dir = ./resources
resources := $(shell find $(resource_dir) -name '*.xml')
source_dir := ./source
sources := $(wildcard $(source_dir)/*.mc)

$(devkey):
	openssl genrsa -out developer_key.pem 4096
	openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem -out $(devkey) -nocrypt

$(app_name).prg: $(manifest) $(devkey) $(resources) $(devkey) $(sources)
	monkeyc -o $@ -m $(manifest) -y $(devkey) $(addprefix -z ,$(resources)) $(sources)

.PHONY : test clean

clean:
	rm -f $<

test: $(app_name).prg
	connectiq
	monkeydo $< fr645