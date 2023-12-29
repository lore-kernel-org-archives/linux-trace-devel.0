Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1297C8BF6
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2662C433C9;
	Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Hf-00000000HmC-0CDu;
	Thu, 28 Dec 2023 22:11:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd library: Fix tracecmd_iterate_events_multi() CPU clean up
Date: Thu, 28 Dec 2023 22:10:13 -0500
Message-ID: <20231229031138.68313-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231229031138.68313-1-rostedt@goodmis.org>
References: <20231229031138.68313-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In tracecmd_iterate_events_multi(), the clean up code at the end of the
function that unlocks and frees the remaining records, iterated the CPUs via
a for loop of 0 through all_cpus. But the kbuffer_read_at_offset() function,
expects the CPU passed in to be that of the handle and not of all the
handles.

That is, if there are two trace.dat files being read, and one has 4 CPUs and
the other has 2, the "all_cpus" variable will be 6. When iterating at the
clean up, when it gets passed 3 (4 CPUs is represented by 0-3) it will then
go to 4 and then 5 for the 2 CPUs trace.dat file. Passing in 4 or 5 to
kbuffer_read_at_offset() will fail. It needs to use the local CPU count of
the trace.dat file.

Fixes: 7f0a59aef63c1 ("trace-cmd library: Have tracecmd_iterate_events() start where it left off")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 42c8312f8395..bf070f057ed0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3143,7 +3143,7 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 		offset = (int)(records[cpu].record->offset & (handle->page_size - 1));
 		free_next(handle, local_cpu);
 		/* Reset the buffer to read the cached record again */
-		kbuffer_read_at_offset(handle->cpu_data[cpu].kbuf, offset, NULL);
+		kbuffer_read_at_offset(handle->cpu_data[local_cpu].kbuf, offset, NULL);
 	}
 
 	free(records);
-- 
2.42.0

