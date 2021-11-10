Class RestTransfer.FileDesc Extends (%Persistent, %JSON.Adaptor)
{

Property File As %Stream.GlobalBinary;

Property Name As %String;

Storage Default
{
<Data name="FileDescDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>File</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^RestTransfer.FileDescD</DataLocation>
<DefaultData>FileDescDefaultData</DefaultData>
<IdLocation>^RestTransfer.FileDescD</IdLocation>
<IndexLocation>^RestTransfer.FileDescI</IndexLocation>
<StreamLocation>^RestTransfer.FileDescS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
