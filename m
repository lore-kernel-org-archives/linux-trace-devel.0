Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79DCBE4F
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7269C433C7;
	Fri,  6 Oct 2023 17:15:36 +0000 (UTC)
Date: Fri, 6 Oct 2023 13:16:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Have TRACEEVAL_SET_*() functions fail on
 wrong type
Message-ID: <20231006131647.0bae5a20@gandalf.local.home>
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

I've hit a few bugs using libtraceeval because of a common cut and paste
error. To assign keys, the following is common to do:

  TRACEEVAL_SET_STRING(keys[0], "string");
  TRACEEVAL_SET_NUMBER(keys[0], 123);

But the above has a bug! The second entry was supposed to be keys[1], and
not keys[0]. This bug had me scratching my head a few times until I found
it. The failure is that passing keys to traceeval_insert() or something
similar, the traceeval_insert() will fail because it's expecting keys[0]
to be a string, but the above converted it to a number.

Help prevent this by passing a string into one of the NUMBER() macros or a
number in the STRING() macro fail to build. It doesn't prevent all
combinations as it is common to pass various size to NUMBER() for example:

  unsigned long long val;
  TRACEEVAL_SET_NUMBER_16(keys[0], val);

The above is allowed, but a string should never go into a number and vice
versa. Catching that should find some bugs at build.

Nothing is done with TRACEEVAL_SET_POINTER() as pointers are totally the
responsibility of the developer.

This also requires that you can not just pass a void pointer to one of the
STRING() macros and it requires a typecast now (as the samples had to be
updated).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h | 28 +++++++++++++++++++++-------
 samples/wake-lat.c  |  4 ++--
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index f332aec289fc..48bc006f7e1d 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -97,13 +97,27 @@ struct traceeval_data {
 		(data).member = (val);				\
 	} while (0)
 
-#define TRACEEVAL_SET_NUMBER(data, val)	     __TRACEEVAL_SET(data, NUMBER, number, val)
-#define TRACEEVAL_SET_NUMBER_8(data, val)    __TRACEEVAL_SET(data, NUMBER_8, number_8, val)
-#define TRACEEVAL_SET_NUMBER_16(data, val)   __TRACEEVAL_SET(data, NUMBER_16, number_16, val)
-#define TRACEEVAL_SET_NUMBER_32(data, val)   __TRACEEVAL_SET(data, NUMBER_32, number_32, val)
-#define TRACEEVAL_SET_NUMBER_64(data, val)   __TRACEEVAL_SET(data, NUMBER_64, number_64, val)
-#define TRACEEVAL_SET_STRING(data, val)	     __TRACEEVAL_SET(data, STRING, string, val)
-#define TRACEEVAL_SET_CSTRING(data, val)     __TRACEEVAL_SET(data, STRING, cstring, val)
+/* Have strings and pointers fail to be set to numbers */
+#define __TRACEEVAL_SET_NUM(data, data_type, member, val)	\
+	do {							\
+		char *__test__[val] __attribute__((unused));	\
+		__TRACEEVAL_SET(data, data_type, member, val);	\
+	} while (0)
+
+/* Have numbers fail to be assigned as strings */
+#define __TRACEEVAL_SET_STR(data, data_type, member, val)		\
+	do {								\
+		char __test__  __attribute__((unused)) = (val)[0];	\
+		__TRACEEVAL_SET(data, data_type, member, val);		\
+	} while (0)
+
+#define TRACEEVAL_SET_NUMBER(data, val)	     __TRACEEVAL_SET_NUM(data, NUMBER, number, val)
+#define TRACEEVAL_SET_NUMBER_8(data, val)    __TRACEEVAL_SET_NUM(data, NUMBER_8, number_8, val)
+#define TRACEEVAL_SET_NUMBER_16(data, val)   __TRACEEVAL_SET_NUM(data, NUMBER_16, number_16, val)
+#define TRACEEVAL_SET_NUMBER_32(data, val)   __TRACEEVAL_SET_NUM(data, NUMBER_32, number_32, val)
+#define TRACEEVAL_SET_NUMBER_64(data, val)   __TRACEEVAL_SET_NUM(data, NUMBER_64, number_64, val)
+#define TRACEEVAL_SET_STRING(data, val)	     __TRACEEVAL_SET_STR(data, STRING, string, val)
+#define TRACEEVAL_SET_CSTRING(data, val)     __TRACEEVAL_SET_STR(data, STRING, cstring, val)
 #define TRACEEVAL_SET_POINTER(data, val)     __TRACEEVAL_SET(data, POINTER, pointer, val)
 
 struct traceeval_type;
diff --git a/samples/wake-lat.c b/samples/wake-lat.c
index 8dc49e0b4064..70c1fad88072 100644
--- a/samples/wake-lat.c
+++ b/samples/wake-lat.c
@@ -36,7 +36,7 @@ static int wakeup_callback(struct tracecmd_input *handle, struct tep_event *even
 	tep_read_number_field(pid_field, record->data, &val);
 	pid = val;
 
-	TRACEEVAL_SET_CSTRING(keys[0], record->data + comm_field->offset);
+	TRACEEVAL_SET_CSTRING(keys[0], (char *)record->data + comm_field->offset);
 	TRACEEVAL_SET_NUMBER(keys[1], pid);
 
 	traceeval_delta_start(data->tdelta, keys, record->ts);
@@ -62,7 +62,7 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	tep_read_number_field(next_pid_field, record->data, &val);
 	pid = val;
 
-	TRACEEVAL_SET_CSTRING(keys[0], record->data + next_comm_field->offset);
+	TRACEEVAL_SET_CSTRING(keys[0], (char *)record->data + next_comm_field->offset);
 	TRACEEVAL_SET_NUMBER(keys[1], pid);
 
 	traceeval_delta_stop(data->tdelta, keys, record->ts);
-- 
2.40.1

