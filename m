Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1461870
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B89C43399;
	Wed, 10 Jan 2024 03:00:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LLe-2RFp;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/7] libtracefs: Have tracefs_mmap_read() include subbuf meta data
Date: Tue,  9 Jan 2024 21:51:46 -0500
Message-ID: <20240110030116.81837-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110030116.81837-1-rostedt@goodmis.org>
References: <20240110030116.81837-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_cpu_read() returns tracefs_mmap_read() when the tcpu is mapped.
But tracefs_cpu_read() is supposed to return the amount that was read, which
includes the sub-buffer meta data. But kbuffer_read_buffer() only returns
the amount of data that was read and does not include the sub-buffer meta
data.

Fixes: 2ed14b59 ("libtracefs: Add ring buffer memory mapping APIs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-mmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index 0f90f51e9339..f481bda37eaf 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -207,5 +207,10 @@ __hidden int trace_mmap_read(void *mapping, void *buffer)
 		return ret;
 
 	/* Update the buffer */
-	return kbuffer_read_buffer(kbuf, buffer, tmap->map->subbuf_size);
+	ret = kbuffer_read_buffer(kbuf, buffer, tmap->map->subbuf_size);
+	if (ret <= 0)
+		return ret;
+
+	/* This needs to include the size of the meta data too */
+	return ret + kbuffer_start_of_data(kbuf);
 }
-- 
2.43.0

