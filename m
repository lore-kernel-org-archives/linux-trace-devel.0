Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707962D0606
	for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jan 2026 20:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767384727; cv=none; b=KGM0r9/k7ea/NJegxD5k0JVHRXRAFA1+UQSlVYiNmm5xHL2HEAP/46JQqjrnuc27FTeHdvdhWreMc5zhB7l9QY7OxTjxUgDwEVR0KqUYCVzhfPi2rqwIfp+RqSaiEVBJdpPAfpA2iV+VKj9KOl8d3rIKRT6OYLgPYndM+6MxDsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767384727; c=relaxed/simple;
	bh=Kuc4hMbkpGmQzw/SGd2ycJNgZFhMIHXdc+pCDkEZV7M=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=F8Kr9cEELxg3Lj22VNAgVx67vKqBqSDYPtZY4ygo/QeIS/ztFmspoTWTlOntRUWnO98ud31B7OhEH1fZI1JxAUmraum63j9WDHP2ZXKXn3fan2A57EGeoFy2RWpkwOvJU1XddARbVl/aysEO3FrHYI40vqhiZGx1JxTXslncU9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E1931A0C49
	for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jan 2026 20:12:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 0C76E17
	for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jan 2026 20:12:01 +0000 (UTC)
Date: Fri, 2 Jan 2026 15:12:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] trace-cmd list: Allow adding a regex to filter out
 showing of options
Message-ID: <20260102151216.088f27cd@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: urcu9r1tnn78i431ttqkdxiiu8jxdxgc
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 0C76E17
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19wLKBGkAX2ii/PtnxMvZ2a0AN2b1DT8qc=
X-HE-Tag: 1767384721-520767
X-HE-Meta: U2FsdGVkX1/Mk5EWkAzIi7c7KBP6y/WO85sgcQ5FUfwBihOjAStl6fTFcFfmXhh2WHVFvjCq5Xd+YLYCtCOXIeOXHo7/M6koWvLx2eZm0mO2ciwd0IFqjKbg+pLEz7edNoaKGi3kXX6ZHgE5Dx4KLAJtR1Y05bvt3NQPcQRUKCbPXeGPHvBFUp1UJoPv0InNOSXYuWAis7KtRfqXk9MNYA2Au97kHKiaizAdr/RIKA6DVJ/wMYI6mehEtJLhrHE/AVl1FDrK5fxtYx0M4TSpu4aH1wGcIke2uYaAgO/8oRyPzG6Cc1UWa84iqCxhk8zLxCAh8omgNFKs9wGUe7j+clNgwgcVAu2QMryk8qMntz6BAhgwV6n6URNk5vMcWqRwB2k3XTMFc9i2KUbXAJkNNA==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The command "trace-cmd list -o" list all the options that are enabled. Most
of the time the user just wants to see a single option. Allow the -o option
to take an optional parameter that will filter the options shown.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/all/20250827204100.2cc9d9b1@gandalf.local.home/

- Fix a missed "show_options()" update

 tracecmd/include/trace-local.h |  2 +-
 tracecmd/trace-list.c          | 19 ++++++++++++++++---
 tracecmd/trace-stat.c          |  2 +-
 3 files changed, 18 insertions(+), 5 deletions(-)

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
 
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 7ac62f2a..41f6358f 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -851,7 +851,7 @@ static void stat_instance(struct buffer_instance *instance, bool opt)
 		    "Filtered function tracer notrace PIDs:\n");
 	if (opt) {
 		printf("\nOptions:\n");
-		show_options("   ", instance);
+		show_options("   ", instance, NULL);
 	}
 	report_traceon(instance);
 	report_file(instance, "error_log", "", "Error log:\n");
-- 
2.50.1

