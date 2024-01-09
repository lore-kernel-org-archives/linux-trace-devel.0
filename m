Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C122E62C
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 02:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A5C433F1
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 02:54:07 +0000 (UTC)
Date: Mon, 8 Jan 2024 21:55:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs sql: Rename TIMESTAMP_USECS_DELTA to
 TIMESTAMP_DELTA_USECS
Message-ID: <20240108215504.27208750@gandalf.local.home>
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

The few times I used the TIMESTAMP_USECS_DELTA I kept writing it as
TIMESTAMP_DELTA_USECS. It makes more sense to add the USECS afterward, and
it's just converting the TIMESTAMP_DELTA to use USECS.

That is, we have:

 TIMESTAMP and TIMESTAMP_USECS

We should then have

 TIMSTAMP_DELTA and TIMESTAMP_DELTA_USECS

which is just converting the TIMESTAMP_DELTA into microseconds from
nanoseconds like TIMESTAMP_USECS converts TIMESTAMP into microseconds from
nanoseconds.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt | 4 ++--
 src/tracefs-sqlhist.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 7921509f3825..806fbe466658 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -134,12 +134,12 @@ Because it is so common to have:
    (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS)
 --
 
-The above can be represented with *TIMESTAMP_USECS_DELTA* or if nanoseconds are OK, you can
+The above can be represented with *TIMESTAMP_DELTA_USECS* or if nanoseconds are OK, you can
 use *TIMESTAMP_DELTA*. That is, the previous select can also be represented by:
 
 [source,c]
 --
-select start.pid, TIMESTAMP_USECS_DELTA as lat from sched_waking as start JOIN sched_switch as end ON start.pid = end.next_pid
+select start.pid, TIMESTAMP_DELTA_USECS as lat from sched_waking as start JOIN sched_switch as end ON start.pid = end.next_pid
 --
 
 
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index e7a4158d1dc2..ecf09ce562ce 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -40,7 +40,7 @@ enum field_type {
 	for (expr = (table)->fields; expr; expr = (field)->next)
 
 #define TIMESTAMP_COMPARE "TIMESTAMP_DELTA"
-#define TIMESTAMP_USECS_COMPARE "TIMESTAMP_USECS_DELTA"
+#define TIMESTAMP_USECS_COMPARE "TIMESTAMP_DELTA_USECS"
 #define EVENT_START	"__START_EVENT__"
 #define EVENT_END	"__END_EVENT__"
 #define TIMESTAMP_NSECS "TIMESTAMP"
-- 
2.43.0

