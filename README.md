# README

Implements a spam filter for [Front](https://frontapp.com) through webhooks and a third party service. This setup requires a special inbox and tag in Front to (manually) classify spam messages. Messages can be marked as spam by moving them into the designated Spam inbox. Moving messages from the spam inbox to a different folder will unmark them as spam. Any message marked as spam, either by the the third party service, or by moving them into the spam inbox, will be tagged with the Spam-tag.

Right now [Plino]()https://plino.herokuapp.com/ is used for spam classification. The service does not support training the algorithm.

## Configuration

The rails credentials/settings file should, aside from the `secret_key_base`, have the following keys:

- token, the token for your api, this will be part of the urls in the Front webhooks
- frontapp_token, the api token for Front
- frontapp_spam_inbox_id, The ID of the spam inbox in Front (see [Configuration in Front])
- frontapp_spam_tag_name, The case-sensitve name of the spam tag in Front (see [Configuration in Front])

## Configuration in Front

You should have a an inbox where the spam messages will be moved to, this can be a regular folder. There also needs to be a Spam-tag, that will be applied to spam messages.

Make sure Webhooks are enabled as an [integration](https://app.frontapp.com/settings/integrations/native).
The spam filter works by triggering webhooks when a new inbound message is received or when a message is moved from or to the spam inbox. Only new inbound messages will be processed, conversations with multiple messages will be ignored.

Configure the rules that should trigger the spam filtering as follows:

### Rule on inbound messages

Create a rule on inbound messages only. Set the condition that the inbox must be included in all inboxes that you want to spam filter. Do not include the specific Spam inbox in the list. As an action, trigger the webhook `http(s)://<your endpoint>/hooks/inbound/<token>`

### Rule on moving messages to mark them as spam

Create a rule on moved messages. Set the conditions that it does not have the Spam-tag. Set the condition that the inbox the Spam inbox. As an action, trigger the webhook `http(s)://<your endpoint>/hooks/move/<token>`

### Rule on moving messages to unmark them as spam

Create a rule on moved messages. Set the conditions that it has the Spam-tag. Set the condition that the inbox must be included in all (relevant) inboxes aside from the Spam inbox. Do not include the specific Spam inbox in the list. As an action, trigger the webhook `http(s)://<your endpoint>/hooks/move/<token>`