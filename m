Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AF628DF0C
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Apr 2025 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744658925; cv=none; b=gFIHl6yuiaw6Nno4O1bGJoGnNiSWT4J4Pc5LJTZsBXb7E8K2/kvpmKszHIquHY3cYwxW7owXlrkz9j0iIizLGnJbXBiKCjccAa21oQn5ipoLTJSQHrbbU5rPPPAGJsEcUj59tWnS9+D+VH++XdMUWPk7NriaFDmL6hTTH5csAuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744658925; c=relaxed/simple;
	bh=2AVqVJoG/hRTCToz1R2OQhwBMsfj0oWzCFDF5ixWDUg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=JuWebJluwO/KM9JUsepvvQ0cvSFkDTXBABfVIGhqUdfqoBj1+xOZCB2xqhkhRIvX/zzUS+ka1cNo2AyqpkZslYeNqxsIVTOlDFYUbTGEYxU4YTVWslzwgD22Z1rfPOUU+aG5eeL/hR0/fnSS7yx1PgJJsVDxIRFRvmB+mI9a51o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E50FC4CEE5
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Apr 2025 19:28:45 +0000 (UTC)
Date: Mon, 14 Apr 2025 15:30:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add support for __print_dynamic_array()
 macro
Message-ID: <20250414153017.2d956a04@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The Linux version v6.13 added a __print_dynamic_array() helper macro that is
basically:

 #define __print_dynamic_array(array, el_size)                          \
        ({                                                              \
                __print_array(__get_dynamic_array(array),               \
                              __get_dynamic_array_len(array) / (el_size), \
                              (el_size));                               \
        })

Add support for in.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 65 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 6317ff6..ba6e42b 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3160,6 +3160,54 @@ out:
 	return TEP_EVENT_ERROR;
 }
 
+static enum tep_event_type
+process_int_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char **tok)
+{
+	struct tep_format_field *field;
+	enum tep_event_type type;
+	char *token;
+
+	memset(arg, 0, sizeof(*arg));
+	arg->type = TEP_PRINT_INT_ARRAY;
+
+	/*
+	 * The first item within the parenthesis is another field that holds
+	 * the index into where the array starts.
+	 */
+	type = tep_read_token(event->tep, &token);
+	if (type != TEP_EVENT_ITEM)
+		return TEP_EVENT_ERROR;
+
+	/* Find the field */
+	field = tep_find_field(event, token);
+	if (!field)
+		goto out;
+
+	if (read_expected(event->tep, TEP_EVENT_DELIM, ",") < 0)
+		goto out;
+
+	arg->int_array.count = NULL;
+
+	if (alloc_and_process_delim(event, ")", &arg->int_array.el_size))
+		goto out;
+
+	arg->int_array.field = alloc_arg();
+	if (!arg) {
+		do_warning_event(event, "%s: not enough memory!", __func__);
+		goto out;
+	}
+
+	arg->int_array.field->type = TEP_PRINT_DYNAMIC_ARRAY;
+	arg->int_array.field->dynarray.field = field;
+	arg->int_array.field->dynarray.index = 0;
+
+	return read_token_item(event->tep, tok);
+out:
+	tep_free_token(token);
+	*tok = NULL;
+	return TEP_EVENT_ERROR;
+}
+
 static enum tep_event_type
 process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 {
@@ -3661,6 +3709,10 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		tep_free_token(token);
 		return process_int_array(event, arg, tok);
 	}
+	if (strcmp(token, "__print_dynamic_array") == 0) {
+		tep_free_token(token);
+		return process_int_dynamic_array(event, arg, tok);
+	}
 	if (strcmp(token, "__get_str") == 0 ||
 	    strcmp(token, "__get_rel_str") == 0) {
 		tep_free_token(token);
@@ -4941,9 +4993,11 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		void *num;
 		int el_size;
 
+		len = 0;
+
 		if (arg->int_array.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
 			dynamic_offset_field(tep, arg->int_array.field->dynarray.field, data,
-					     size, &offset, NULL);
+					     size, &offset, &len);
 			num = data + offset;
 		} else {
 			field = arg->int_array.field->field.field;
@@ -4956,9 +5010,16 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			}
 			num = data + field->offset;
 		}
-		len = eval_num_arg(data, size, event, arg->int_array.count);
 		el_size = eval_num_arg(data, size, event,
 				       arg->int_array.el_size);
+
+		if (arg->int_array.count) {
+			len = eval_num_arg(data, size, event, arg->int_array.count);
+		} else {
+			/* __print_dynamic_array() has a dynamic count */
+			if (el_size)
+				len /= el_size;
+		}
 		trace_seq_putc(s, '{');
 		for (i = 0; i < len; i++) {
 			if (i)
-- 
2.47.2

