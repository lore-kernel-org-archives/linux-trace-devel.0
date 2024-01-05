Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0A1C687
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 05:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74770C433C8;
	Fri,  5 Jan 2024 05:20:35 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLceM-00000000xZu-3Iql;
	Fri, 05 Jan 2024 00:21:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs synthetic: Handle hashed name variables
Date: Fri,  5 Jan 2024 00:21:01 -0500
Message-ID: <20240105052141.228999-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240105052141.228999-1-rostedt@goodmis.org>
References: <20240105052141.228999-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When running:

 sqlhist -m delta -n 'wakeup' 'select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid'

The '-m delta' is supposed to set the "onmax()" to the "delta" variable. But
this fails because the output would be:

  echo 'hist:keys=next_pid:__pid_17298_1=$__arg_17298_2,__delta_17298_4=common_timestamp.usecs-$__arg_17298_3:onmax($delta).trace(wakeup,$__pid_17298_1,$__delta_17298_4)'

As the "delta" was hashed to __delta_17298_4 and the "onmax()" has "$delta"
unhashed. In actuality, it wouldn't even get that far as the "test_max_var()"
will flag it as the variable does not exist (because it's not "delta" but
"__delta_17298_4").

Modify test_max_var() to check for hashed variables and return the one it
found.

Fixe: 00c6b5f6 ("libtracefs: Use unique names for sql field variables")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 80 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 70 insertions(+), 10 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 5f32ec305409..2b4f17f2f6ec 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -13,6 +13,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <ctype.h>
 #include <sys/time.h>
 #include <sys/types.h>
 
@@ -1687,27 +1688,81 @@ int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				   type, field, compare, val);
 }
 
-static int test_max_var(struct tracefs_synth *synth, const char *var)
+static bool var_match(const char *match, const char *var, int match_len, int len)
+{
+	char copy[match_len + 1];
+	char *p, *e;
+
+	strncpy(copy, match, match_len + 1);
+	copy[match_len] = '\0';
+
+	p = copy;
+
+	if (*p == '$')
+		p++;
+
+	if (strncmp(p, var, len) == 0)
+		return true;
+
+	/* Check if this was hashed __<var>_<number>_<number> */
+	if (p[0] != '_' || p[1] != '_')
+		return false;
+
+	p += 2;
+
+	e = copy + match_len - 1;
+	if (!isdigit(*e))
+		return false;
+	while (isdigit(*e) && e > p)
+		e--;
+	if (e == p || *e != '_')
+		return false;
+
+	e--;
+	if (!isdigit(*e))
+		return false;
+	while (isdigit(*e) && e > p)
+		e--;
+	if (e == p || *e != '_')
+		return false;
+
+	if (e - p != len)
+		return false;
+
+	*e = '\0';
+
+	return strncmp(p, var, len) == 0;
+}
+
+static char *test_max_var(struct tracefs_synth *synth, const char *var)
 {
 	char **vars = synth->end_vars;
+	char *ret;
 	char *p;
 	int len;
 	int i;
 
 	len = strlen(var);
+	if (var[0] == '$') {
+		var++;
+		len--;
+	}
 
 	/* Make sure the var is defined for the end event */
 	for (i = 0; vars[i]; i++) {
 		p = strchr(vars[i], '=');
 		if (!p)
 			continue;
-		if (p - vars[i] != len)
-			continue;
-		if (!strncmp(var, vars[i], len))
-			return 0;
+
+		if (var_match(vars[i], var, p - vars[i], len)) {
+			i = asprintf(&ret, "%.*s", (int)(p - vars[i]), vars[i]);
+			if (i < 0)
+				return NULL;
+			return ret;
+		}
 	}
 	errno = ENODEV;
-	return -1;
+	return NULL;
 }
 
 static struct action *create_action(enum tracefs_synth_handler type,
@@ -1715,14 +1770,16 @@ static struct action *create_action(enum tracefs_synth_handler type,
 				    const char *var)
 {
 	struct action *action;
+	char *newvar = NULL;
 	int ret;
 
 	switch (type) {
 	case TRACEFS_SYNTH_HANDLE_MAX:
 	case TRACEFS_SYNTH_HANDLE_CHANGE:
-		ret = test_max_var(synth, var);
-		if (ret < 0)
+		newvar = test_max_var(synth, var);
+		if (!newvar)
 			return NULL;
+		var = newvar;
 		break;
 	default:
 		break;
@@ -1730,15 +1787,18 @@ static struct action *create_action(enum tracefs_synth_handler type,
 
 	action = calloc(1, sizeof(*action));
 	if (!action)
-		return NULL;
+		goto out;
 
 	if (var) {
 		ret = asprintf(&action->handle_field, "$%s", var);
-		if (!action->handle_field) {
+		if (ret < 0) {
 			free(action);
+			free(newvar);
 			return NULL;
 		}
 	}
+ out:
+	free(newvar);
 	return action;
 }
 
-- 
2.42.0

