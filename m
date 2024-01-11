Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F58258AAE
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DB7C43390;
	Thu, 11 Jan 2024 22:20:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rO3R3-00000000eGd-3DFG;
	Thu, 11 Jan 2024 17:22:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracecmd: Use cpu_data[cpu]->cpus and not ->max_cpu
Date: Thu, 11 Jan 2024 17:15:36 -0500
Message-ID: <20240111222201.154686-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111222201.154686-1-rostedt@goodmis.org>
References: <20240111222201.154686-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The handle->cpu_data[cpu]->max_cpu is the largest number CPU that is
recorded in the trace, where as cpu_data[cpu]->cpus is the number of
handle->cpu_data[] entries.

The iterator loops mistakenly used the max_cpu field instead of the cpus
field and this can cause errors if the two are not the same. This is the
case if one of the CPUs contained no data, it will not have a cpu_data[]
entry and will be skipped.

Fixes: 2cb6cc2f4 ("tracecmd library: Add tracecmd_iterate_events()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6297e34bde38..0dc3dbdc676a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2819,11 +2819,11 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 		return -1;
 	}
 
-	records = calloc(handle->max_cpu, sizeof(*records));
+	records = calloc(handle->cpus, sizeof(*records));
 	if (!records)
 		return -1;
 
-	for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+	for (cpu = 0; cpu < handle->cpus; cpu++) {
 		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
 			continue;
 
@@ -2832,7 +2832,7 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 
 	do {
 		next_cpu = -1;
-		for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+		for (cpu = 0; cpu < handle->cpus; cpu++) {
 			record = records[cpu];
 			if (!record)
 				continue;
@@ -2855,7 +2855,7 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 	} while (next_cpu >= 0 && ret == 0);
 
 	/* Need to unlock and free the records */
-	for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+	for (cpu = 0; cpu < handle->cpus; cpu++) {
 		int offset;
 
 		if (!records[cpu])
@@ -3025,7 +3025,7 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 	struct tep_record **records;
 	struct tep_record *record;
 	int next_cpu;
-	int max_cpus = handle->max_cpu;
+	int max_cpus = handle->cpus;
 	int cpu;
 	int ret = 0;
 
@@ -3119,7 +3119,7 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 
 	for (i = 0; i < nr_handles; i++) {
 		handle = handles[i];
-		cpus += handle->max_cpu;
+		cpus += handle->cpus;
 	}
 
 	records = calloc(cpus, sizeof(*records));
@@ -3129,7 +3129,7 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 	for (i = 0; i < nr_handles; i++) {
 		handle = handles[i];
 		handle->start_cpu = all_cpus;
-		for (cpu = 0; cpu < handle->max_cpu; cpu++) {
+		for (cpu = 0; cpu < handle->cpus; cpu++) {
 			records[all_cpus + cpu].record = tracecmd_peek_data(handle, cpu);
 			records[all_cpus + cpu].handle = handle;
 		}
-- 
2.43.0

