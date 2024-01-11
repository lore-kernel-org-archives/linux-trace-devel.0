Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A291CF88
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCB2C43390
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:37:06 +0000 (UTC)
Date: Thu, 11 Jan 2024 17:38:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix tracefs_instance_reset() of triggers
Message-ID: <20240111173809.7d5462e8@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The clearing of triggers may require a few loops as the order of the
clearing is important. Some triggers rely on other triggers to be cleared
before they can be cleared.

The tracefs_instance_reset() will loop over all the triggers, clearing them
one at a time, and restart from the top again if not all the triggers were
cleared. This guarantees that the triggers will have other triggers cleared
first if they depend on them to be cleared.

The "file" string used to clear the trigger wasn't updated to equal the next
file in the list, so it was stale.

Fixes: 93e20af8 ("libtracefs: Fix tracefs_instance_reset to clear synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 0ee0225..9a26708 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1539,6 +1539,7 @@ void tracefs_instance_reset(struct tracefs_instance *instance)
 		list_size = tracefs_list_size(file_list);
 		file_list = NULL;
 		for (i = 0; list[i]; i++) {
+			file = list[i];
 			ret = clear_trigger(file);
 			if (ret) {
 				char **tlist;
-- 
2.42.0

