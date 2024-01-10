Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A07D3234
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09781C433B1;
	Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LLk-2fEy;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/7] libtracefs: Fix tracefs_mmap() kbuf usage
Date: Tue,  9 Jan 2024 21:51:48 -0500
Message-ID: <20240110030116.81837-5-rostedt@goodmis.org>
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

The tracefs_mmap() function used the "kbuf" variable instead of the
"tmap->kbuf" variable which caused confusion later on.

The kbuf passed in is only used to make the "duplicate" for tmap->kbuf, so
once that is done, just assign kbuf = tmap->kbuf and use "kbuf" throughout
the rest of the function to avoid confusion.

Fixes: 2ed14b594f669 ("libtracefs: Add ring buffer memory mapping APIs")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-mmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
index f481bda37eaf..e0e37681e019 100644
--- a/src/tracefs-mmap.c
+++ b/src/tracefs-mmap.c
@@ -81,6 +81,7 @@ __hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
 		munmap(meta, page_size);
 		free(tmap);
 	}
+	kbuf = tmap->kbuf;
 
 	tmap->fd = fd;
 
@@ -91,7 +92,7 @@ __hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
 		munmap(meta, page_size);
 		meta = mmap(NULL, tmap->meta_len, PROT_READ, MAP_SHARED, fd, 0);
 		if (meta == MAP_FAILED) {
-			kbuffer_free(tmap->kbuf);
+			kbuffer_free(kbuf);
 			free(tmap);
 			return NULL;
 		}
@@ -106,7 +107,7 @@ __hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
 			  fd, tmap->meta_len);
 	if (tmap->data == MAP_FAILED) {
 		munmap(meta, tmap->meta_len);
-		kbuffer_free(tmap->kbuf);
+		kbuffer_free(kbuf);
 		free(tmap);
 		return NULL;
 	}
-- 
2.43.0

