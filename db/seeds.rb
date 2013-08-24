User.delete_all
Task.delete_all

user = User.create(name: "JC Grubbs", email: "jc@devmynd.com", password: "pass1234")

[
  "Write up SOW for Acme, Inc.",
  "Send in tax forms",
  "Call Steve about the client paperwork",
  "Send proofs to Jeff S.",
  "Prepare presentation for ThatConference",
  "Put up new copy on the website",
  "Send invoice to Acme, Inc.",
  "Pick up stamps",
  "File annual report with IL",
  "Birthday present for Sarah",
  "Fix open issues in the Tabs gem",
  "Send out Auguest newsletter",
  "New presentation template"
].each do |name|
  user.tasks.create(name: name, state: "now")
end

[
  "Plan for the company party",
  "Write outline for the book",
  "Move payroll system to ADP",
  "Order the new signage",
  "Mail contracts to Acme, Inc."
].each do |name|
  user.tasks.create(name: name, state: "later")
end

[
  "Get list of vendors for conference",
  "Schedule catering for training week",
  "Finalize dates for fishing trip"
].each do |name|
  user.tasks.create(name: name, state: "done")
end
