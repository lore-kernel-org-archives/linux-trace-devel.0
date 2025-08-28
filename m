Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28F8B665
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Aug 2025 00:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756341652; cv=none; b=sgm/yMDSvef2E/oNgEl9t2ThkYN0XrmCLPGbzvBAwHJ3s6O5d5vK73VrdxxjNEnTCcao+FmloYgYe2jDg/5wtX6D2CuLy23H0j0CXnr5wOABa51e9mkK+4EYoN3C7RCVVdEcXSgJ8EjLV7v/0wQNdNcBsGli2pTNjtg8e8YY0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756341652; c=relaxed/simple;
	bh=Yngw8o73HaikkVQDqMGDfFGWNEwbZdyagBjpZ8mLXes=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=dSlhMaRcaXW8DjvHtgteBAP3d6H62P9xgVgOi+ywYngO2ktrFcXwdHvJ8kM1j6N3XYCzpTIjYD4jlLXnI/l3UxXKM51MvLhUjVnFiekarPZAxtRaUaBLOTFoouq6KyE2wk11LcPMHjep8DlRQjRNbKRVfREP/QEl7MSfeHtOKk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A8851DEA6C
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Aug 2025 00:40:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id DEF198000E
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Aug 2025 00:40:41 +0000 (UTC)
Date: Wed, 27 Aug 2025 20:41:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd list: Allow adding a regex to filter out showing
 of options
Message-ID: <20250827204100.2cc9d9b1@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: DEF198000E
X-Stat-Signature: cci4jp4oj1badwocgzu8d4hcj8nwq4yz
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+7kfDsdLroWSfq6sfR7cVCLGIgANHpTCA=
X-HE-Tag: 1756341641-463849
X-HE-Meta: U2FsdGVkX1/OOt5AMeODGycga7r+mmXi90yGmSj0PpuSLq8bKmx3o1ygQ3XaQ0DtN/sDAvVWn3uIzlHKEVGOKjRYd9d214MhU/hvKO7Z5wqdSCatg849ySAUqO5k1EEJHyWnp5ntAivDaV5/cfkOBho0ilRv5bSIjUOC/spDeqsvrbZpy2M3P8msU12Aj5/p+cD7ctGk1laOpNf+vD893p5jYmroPqHdOZYTQtBWvtpmLHvkhSOMfetESw8BDh5w/wVfDIALKnBww59aKpy3R+4JwMqsylPCsyo3cFgvX/NtgbLphDnR+EhHdFuBqPp9FIkrC5RHSwoNpvG+YS9vGX/p1u4JRJR5NYa+8R6ejM2FvLJcM0bVLfQ9AO5e3xys

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The command "trace-cmd list -o" list all the options that are enabled. Most
of the time the user just wants to see a single option. Allow the -o option
to take an optional parameter that will filter the options shown.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  2 +-
 tracecmd/trace-list.c          | 19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 54a1b51e..4ad07b63 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -343,7 +343,7 @@ void add_instance(struct buffer_instance *instance, int cpu_count);
 void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
-void show_options(const char *prefix, struct buffer_instance *buffer);
+void show_options(const char *prefix, struct buffer_instance *buffer, const char *re);
 
 struct trace_guest {
 	struct tracefs_instance *instance;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 073b37fb..b9e23f66 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -389,14 +389,22 @@ static void show_tracers(void)
 	show_file("available_tracers");
 }
 
-void show_options(const char *prefix, struct buffer_instance *buffer)
+void show_options(const char *prefix, struct buffer_instance *buffer, const char *re)
 {
 	struct tracefs_instance *instance = buffer ? buffer->tracefs : NULL;
 	struct dirent *dent;
 	struct stat st;
+	regex_t reg;
 	char *path;
 	DIR *dir;
 
+	if (re && strlen(re)) {
+		if (regcomp(&reg, re, REG_ICASE|REG_NOSUB))
+			die("invalid function regex '%s'", re);
+	} else {
+		re = NULL;
+	}
+
 	if (!prefix)
 		prefix = "";
 
@@ -423,6 +431,9 @@ void show_options(const char *prefix, struct buffer_instance *buffer)
 		    strcmp(name, "..") == 0)
 			continue;
 
+		if (re && regexec(&reg, name, 0, NULL, 0) != 0)
+			continue;
+
 		ret = asprintf(&file, "options/%s", name);
 		if (ret < 0)
 			die("Failed to allocate file name");
@@ -645,6 +656,7 @@ void trace_list(int argc, char **argv)
 	const char *arg;
 	const char *funcre = NULL;
 	const char *eventre = NULL;
+	const char *optionre = NULL;
 
 	for (i = 2; i < argc; i++) {
 		arg = NULL;
@@ -694,6 +706,7 @@ void trace_list(int argc, char **argv)
 				break;
 			case 'o':
 				options = 1;
+				optionre = arg;
 				show_all = 0;
 				break;
 			case 'f':
@@ -735,7 +748,7 @@ void trace_list(int argc, char **argv)
 		show_tracers();
 
 	if (options)
-		show_options(NULL, NULL);
+		show_options(NULL, NULL, optionre);
 
 	if (plug)
 		show_plugins();
@@ -763,7 +776,7 @@ void trace_list(int argc, char **argv)
 		printf("\ntracers:\n");
 		show_tracers();
 		printf("\noptions:\n");
-		show_options(NULL, NULL);
+		show_options(NULL, NULL, NULL);
 		show_compression();
 	}
 
-- 
2.47.2

