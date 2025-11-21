Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D022D8DD1
	for <linux-trace-devel@vger.kernel.org>; Fri, 21 Nov 2025 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744959; cv=none; b=f8ZeQ6Y/Ee7LBqAd/TglqWAb+CbLNJATSXD6+f0qzH3iK3aQsbeOm0YePpL5cQSrHiiU0A5qlccOk35oYaEJXmtiFRSfKmqV2HyisShbVF2k7dNGR0kP/I63qPxLwy2LH5Qb8AP5p/X1pcBI6MaihuJ8Q60wwriCye7hEcE9Ank=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744959; c=relaxed/simple;
	bh=q1NIkOxlZ4pAjNM19vggPJtDAQiddDZRCvvShvrppdw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Fs3QrRFcwQQjrmUlo8Fio8PC6UTGmgAiMJzcUrKW/tXWTieaWPsswXooCtTc1C342gHV3w2jahNKMYnE/6Zo7eDYRAOVRd74ArxurUctTCzx1wSPdDgnIDhi7jtmWjIz7rBkGqlGd2oxXdbUDan3euhz4yVOJF/hO4siojC2qRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 991AF59E26;
	Fri, 21 Nov 2025 17:09:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 42E1C20025;
	Fri, 21 Nov 2025 17:09:13 +0000 (UTC)
Date: Fri, 21 Nov 2025 12:09:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH] libtracecmd: Fix continuing in
 tracecmd_iterate_events_reverse()
Message-ID: <20251121120947.368ad1bd@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 42E1C20025
X-Stat-Signature: i3ioa4csdinhsna4xmobay671ypopzp7
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/b73axK5AukvdIn6WLnofPdTq5t7TZoeU=
X-HE-Tag: 1763744953-901312
X-HE-Meta: U2FsdGVkX1+Btsl3ljIxGmKRxJM5Rcx9z50ZL56gK3s5JzPxJ515h0DMYj31lA0klJFHBBcPd9bjcgf7n7T7ZW7DuWlqEKi5gF5wjp0eFUaX/be5B+IaVcmrc/DKCsb6J+RmKf196pKdvEHWwM7GcSk93ltQ2fA8WO72hkcEaFbnSfXEk4f3NxMkKCcmXIkbk9A6UsMVd+lHqvEcPJZ2Wc3W5D3b0o6YV+caVLa+TmzhC9Q5GQTeLLHcwcdIaGBfMLJxPWwE0dvjYtLfFXIypQpe91epOEL3CS2VKKSDAyqeAKUz0gQ8ov4+hWoX7HTCT/gLOUw1XUcOxeEkRjaMwBWs24XeBBBmnu6lPNiPac8kW9h+eQIM4ETRrCCXegqn7nBjEq/mLD1ZeMCm0NiIqg==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a callback from tracecmd_iterate_events_reverse() returns non-zero it
cause the function to exit out early. Calling tracecmd_iterate_events_reverse()
again with cont=true, is supposed to restart where it left off. But
because of the way the reverse traverses all the events on a page, by
calling tracecmd_read_data() to find the next task, it does not pick the
next task. It can pick the next task at the start of the page.

If the callback back causes the function to exit out early, record the
page_offset of the last record read, and then set the cursor back to that
event.

Link: https://lore.kernel.org/all/20251121120117.20e82d9e@gandalf.local.home/

Fixes: 56cbc522518a5 ("trace-cmd library: Add tracecmd_iterate_events_reverse() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index afdbd2aa98b6..8dfeff458485 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3036,6 +3036,7 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 				    void *callback_data, bool cont)
 {
 	unsigned long long last_timestamp = 0;
+	unsigned long long page_offset = 0;
 	struct tep_record **records;
 	struct tep_record *record;
 	int next_cpu;
@@ -3072,6 +3073,8 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 			record = next_last_event(handle, records, next_cpu);;
 			ret = call_callbacks(handle, record, next_cpu,
 					     callback, callback_data);
+			if (ret)
+				page_offset = record->offset;
 			tracecmd_free_record(record);
 		}
 	} while (next_cpu >= 0 && ret == 0);
@@ -3079,6 +3082,17 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 	free_last_events(handle, records, cpus, cpu_size, max_cpus);
 	free(records);
 
+	/*
+	 * If the callback exited out early, then set the cursor back
+	 * to the location of that record so that if this gets called
+	 * again with cont = true, it will continue where it left off.
+	 */
+	if (page_offset) {
+		/* Set the record to the previous record that was read */
+		record = tracecmd_read_at(handle, page_offset - 4, NULL);
+		tracecmd_free_record(record);
+	}
+
 	return ret;
 }
 
-- 
2.51.0

