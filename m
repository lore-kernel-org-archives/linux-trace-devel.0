Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F54558AAD
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6D4C433F1;
	Thu, 11 Jan 2024 22:20:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rO3R3-00000000eGg-3KnC;
	Thu, 11 Jan 2024 17:22:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracecmd: Do not free records at end of iterator
Date: Thu, 11 Jan 2024 17:15:37 -0500
Message-ID: <20240111222201.154686-3-rostedt@goodmis.org>
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

I'm not sure why the records that were saved in the "peek" were freed, as
they should be freed when the tracecmd_input is closed.

Remove the freeing of the "peek" records, as it should be unneeded.

This basically reverts:

  890855541 ("tracecmd library: Unlock records in tracecmd_iterate_events()")

And commits that simulated it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 63 -------------------------------------
 1 file changed, 63 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0dc3dbdc676a..bc937b0491d7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2854,19 +2854,6 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 		}
 	} while (next_cpu >= 0 && ret == 0);
 
-	/* Need to unlock and free the records */
-	for (cpu = 0; cpu < handle->cpus; cpu++) {
-		int offset;
-
-		if (!records[cpu])
-			continue;
-
-		offset = (int)(records[cpu]->offset & (handle->page_size - 1));
-		free_next(handle, cpu);
-		/* Reset the buffer to read the cached record again */
-		kbuffer_read_at_offset(handle->cpu_data[cpu].kbuf, offset, NULL);
-	}
-
 	free(records);
 
 	return ret;
@@ -2909,25 +2896,6 @@ load_records(struct tracecmd_input *handle, int cpu,
 	return last_record;
 }
 
-static void free_last_record(struct tracecmd_input *handle, struct tep_record *record,
-			     int cpu)
-{
-	record->priv = handle->cpu_data[cpu].page;
-	tracecmd_free_record(record);
-}
-
-static void free_last_records(struct tracecmd_input *handle, struct tep_record *records,
-			      int cpu)
-{
-	struct tep_record *last_record;
-
-	while (records) {
-		last_record = records;
-		records = last_record->priv;
-		free_last_record(handle, last_record, cpu);
-	}
-}
-
 static void initialize_last_events(struct tracecmd_input *handle,
 				   struct tep_record **last_records,
 				   cpu_set_t *cpu_set, int cpu_size,
@@ -3062,20 +3030,6 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 		}
 	} while (next_cpu >= 0 && ret == 0);
 
-	for (cpu = 0; cpu < max_cpus; cpu++) {
-		int offset;
-
-		/* Get the next record to set the index to. */
-		record = peek_last_event(handle, records, cpu);
-		if (!record)
-			continue;
-		/* Reset the buffer to read the cached record again */
-		offset = record->offset & (handle->page_size - 1);
-		free_last_records(handle, records[cpu], cpu);
-		/* Reset the buffer to read the cached record again */
-		kbuffer_read_at_offset(handle->cpu_data[cpu].kbuf, offset, NULL);
-	}
-
 	free(records);
 
 	return ret;
@@ -3164,23 +3118,6 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 
 	} while (next_cpu >= 0 && ret == 0);
 
-	/* Unlock and free the records */
-	for (cpu = 0; cpu < all_cpus; cpu++) {
-		int local_cpu;
-		int offset;
-
-		if (!records[cpu].record)
-			continue;
-
-		handle = records[cpu].handle;
-		local_cpu = cpu - handle->start_cpu;
-
-		offset = (int)(records[cpu].record->offset & (handle->page_size - 1));
-		free_next(handle, local_cpu);
-		/* Reset the buffer to read the cached record again */
-		kbuffer_read_at_offset(handle->cpu_data[local_cpu].kbuf, offset, NULL);
-	}
-
 	free(records);
 
 	return ret;
-- 
2.43.0

