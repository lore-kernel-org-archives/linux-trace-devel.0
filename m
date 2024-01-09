Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F553D98C
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4772FC43390;
	Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNJ45-00000000JKL-1EUc;
	Tue, 09 Jan 2024 15:51:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] libtracefs: Unmap mmap mapping on tracefs_cpu close
Date: Tue,  9 Jan 2024 15:48:56 -0500
Message-ID: <20240109205112.74225-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240109205112.74225-1-rostedt@goodmis.org>
References: <20240109205112.74225-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_cpu_open_mapped() will mmap the ring buffer if it is supported,
but it does not unmap it when it is closed.

Fixes: 2ed14b59 ("libtracefs: Add ring buffer memory mapping APIs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index f51e18420bc7..4a59c61c195f 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -276,6 +276,7 @@ void tracefs_cpu_free_fd(struct tracefs_cpu *tcpu)
 	close_fd(tcpu->splice_pipe[0]);
 	close_fd(tcpu->splice_pipe[1]);
 
+	trace_unmap(tcpu->mapping);
 	kbuffer_free(tcpu->kbuf);
 	free(tcpu);
 }
-- 
2.43.0

