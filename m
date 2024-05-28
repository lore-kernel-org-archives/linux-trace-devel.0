Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446962563
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 May 2024 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716922341; cv=none; b=EB7a1+PqV2/UqDF4l2Vmq11BrzAHP802T/cKt3dQfZ+IjkQBKBprIA+89JTnjR1c2u4etwZ5AmZ5OsabHvLEA0nZRRZIiqzKohbRnAVasnaDOdRoC+yCK5LXJ5jQ5FEY/RiRdSWKQlNx9YotfVsinjmuU2uaOKiXnyWMa9LC8j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716922341; c=relaxed/simple;
	bh=LxboLeQJzYpczHtu88w6h5w4vkQMK1fpqTHJ02MOPzM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=MffSExTCqwErxtTiR30VFMweo5o/3LwSvdQLz/tRRusrQkJAEWAam0XqaSVGpkMMwQ+U2TlmrBVfZyDCecBCal5AsvBbJ9UgKWQtc4qyNfZt2HOwl1SGWw2JsL0wo8OL0Qg/r4UAf8+DtldmZM4qn/jVhHoOaaumK4qeLA2GZaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B89CC3277B
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 May 2024 18:52:20 +0000 (UTC)
Date: Tue, 28 May 2024 14:52:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Optimize what cpus to check in
 tracecmd_iterate_events()
Message-ID: <20240528145219.7cef53b0@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently, tracecmd_iterate_events() will look at all possible CPUs to
find the next event to print, even if the CPUs to look at are filtered.
Instead, create a list of all the CPUs to look at and iterate that, such
that only the CPUs that are needed are looked at instead of all of them,
including those that are filtered out.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ce4ecf43..2d12ac33 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2813,9 +2813,12 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 	struct tep_record *record;
 	unsigned long long *timestamps;
 	unsigned long long ts, last_timestamp = 0;
+	int *cpu_list;
+	int cpu_count = 0;
 	int next_cpu;
 	int cpu;
 	int ret = 0;
+	int i;
 
 	if (!callback && !handle->nr_followers) {
 		errno = EINVAL;
@@ -2826,17 +2829,28 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 	if (!timestamps)
 		return -1;
 
+	cpu_list = calloc(handle->cpus, sizeof(*cpu_list));
+	if (!cpu_list) {
+		free(timestamps);
+		return -1;
+	}
+
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
 		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
 			continue;
+		cpu_list[cpu_count++] = cpu;
+	}
 
+	for (i = 0; i < cpu_count; i++) {
+		cpu = cpu_list[i];
 		record = tracecmd_peek_data(handle, cpu);
 		timestamps[cpu] = record ? record->ts : -1ULL;
 	}
 
 	do {
 		next_cpu = -1;
-		for (cpu = 0; cpu < handle->cpus; cpu++) {
+		for (i = 0; i < cpu_count; i++) {
+			cpu = cpu_list[i];
 			ts = timestamps[cpu];
 			if (ts == -1ULL)
 				continue;
@@ -2869,6 +2883,7 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 	} while (next_cpu >= 0 && ret == 0);
 
 	free(timestamps);
+	free(cpu_list);
 
 	return ret;
 }
-- 
2.43.0

