Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE90A1624D5
	for <linux-trace-devel@vger.kernel.org>; Thu,  4 Dec 2025 03:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764817443; cv=none; b=L+8ANb3W5/Ht4e1aR+6XCaluTDHZP2L2GzIKfGnNyjfjO9ZwG938obhTYdUOjEi6e7jnYvUYUgNT+O3hqvN1oHm8SWAc9ZIzct7JIt71zLj7gPVMtPasohlCGz7wqlcVji/WQu0sjSeeeVHqAtNMHaASr49bDmEqyX4+I+SpB3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764817443; c=relaxed/simple;
	bh=paaRq1/4vFusxuL80VqVEsPLJ/NdnRfrl83/PxrZit4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=VStJnzx8sCD7cK5ws9LI8UDNPgbWPkWr71PxuvHHoek+n8USQOJ0DFfa0dDKh2pcc1I0+qZfyWlR/7KO/4rGfzX49vVqHDZKlpo+xn0ldq/jGebifkbOv6putplMG7BZwyRIMlYkNdlUdlYBBN0AiEsCQaeyzVHKqMEWS6Ner0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F2921A0906;
	Thu,  4 Dec 2025 03:03:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 3CE8335;
	Thu,  4 Dec 2025 03:03:54 +0000 (UTC)
Date: Wed, 3 Dec 2025 22:03:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH v2] libtracecmd: Fix continuing in
 tracecmd_iterate_events_reverse()
Message-ID: <20251203220353.4c520524@robin>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3CE8335
X-Stat-Signature: pach9nd53hcj9g7czth6wk5j7dctfddm
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+0zRtdvyF6LmKjVle1JarkrdpZT4sqYEU=
X-HE-Tag: 1764817434-240660
X-HE-Meta: U2FsdGVkX1/+7r+x6+7f9/+WgLWYl58GoxZfgVtXpVnIcsCW/w+io1vRSc+XrQNlihqH78YMIe2ZyAbn0mizgclPFbv3h81luNzGrkTWiQVKfa+4Il+E/6EAIahTBz3XnX0msSVOMeyQWJ++FRccSp+BeCTkhNP506RvdPl02rzQci/D9QHub0cTvr38969FR8yrufVD5het6Xss62WAyI3pL45Ak3BDmsoyyaAtJoTIeBb1RV6K+P0RzpyER52SBNUTriH8S5pXezbOxoAp8xGAe8iihkkx2xyh30S0F96o87J6ZOMCVacjflpPw0qFjFfZL0cM1ZyL6W15AFIYelE6s5Gtpz7RzXnVNMnhYK0ae8M+PY6zSRWnmbqvDAhO7+zq8uSHETuDOsa6jXSofQ==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a callback from tracecmd_iterate_events_reverse() returns non-zero it
cause the function to exit out early. Calling tracecmd_iterate_events_reverse()
again with cont=true, is supposed to restart where it left off. But
because of the way the reverse traverses all the events on a page, by
calling tracecmd_read_data() to find the next task, it does not pick the
next task. It can pick the next task at the start of the page.

If the callback back causes the function to exit out early, record the
page_offset of the last record read, and then set the cursor back to that
event. Then the next tracecmd_iterate_events_reverse() called with
continue will start with the next record after the one that was last
read.

Link: https://lore.kernel.org/all/20251121120117.20e82d9e@gandalf.local.home/

Fixes: 56cbc522518a5 ("trace-cmd library: Add tracecmd_iterate_events_reverse() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---

[ RESEND to the correct mailing list this time ]

Changes since v1: https://lore.kernel.org/all/20251121120947.368ad1bd@gandalf.local.home/

- Make the next call to tracecmd_iterate_events_reverse() start with
  the next record after the last one read and not the last one that was
  read.

 lib/trace-cmd/trace-input.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index afdbd2aa98b6..5cb13c3f804b 100644
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
+		/* Set the internal cursor to the last record that was read */
+		record = tracecmd_read_at(handle, page_offset, NULL);
+		tracecmd_free_record(record);
+	}
+
 	return ret;
 }
 
-- 
2.51.0

