# supX: whatsapp extractor
Dump your WhatsApp conversations into cool html.

## What do you need
A folder (lets call it data) with:

* **msgstore.db**: whatsapp messages database
* **wa.db**: whatsapp contacts database (optional)
* **media**: folder with all whatsapp media

## Usage

```ruby
>> require 'supx'
true

>> supx = Supx::SupxManager.new('data')
#<Supx::SupxManager:[..]>

>> supx.contact_list
[{:number=>"000000000000", :name=>"name1"}, {:number=>"000000000001", :name=>"name2"}, .. ]

>> html = supx.read_messages('000000000000')
>> File.open('wa_dump.html', 'w') {|f| f.write(html) }
```

## TODO & bugs
* there's no support for group conversations

