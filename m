Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCCA3608E
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ACAC433C7;
	Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLq3E-000000013v1-2kL9;
	Fri, 05 Jan 2024 14:40:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] kbuffer: Update kbuf->next in kbuffer_refresh()
Date: Fri,  5 Jan 2024 14:37:44 -0500
Message-ID: <20240105194015.253165-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240105194015.253165-1-rostedt@goodmis.org>
References: <20240105194015.253165-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the kbuffer was read to completion, the kbuf->curr would equal both the
size and kbuf->next. The kbuffer_refresh() is to update the kbuf if more
data was added to the buffer. But if curr is at the end, the next pointer
was not updated, which is incorrect. The next pointer needs to be moved to
the end of the newly written event.

Update the pointers in kbuffer_refresh() just as if it was loaded new (but
still keeping curr at the correct location).

Link: https://lore.kernel.org/linux-trace-devel/ZZfJQTOyl0dHiTU-@google.com/

Reported-by: Vincent Donnefort <vdonnefort@google.com>
Fixes: 7a4d5b24 ("kbuffer: Add kbuffer_refresh() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/kbuffer-parse.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 4801d432c58c..1e1d168b534c 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -299,6 +299,9 @@ void kbuffer_free(struct kbuffer *kbuf)
 	free(kbuf);
 }
 
+static unsigned int old_update_pointers(struct kbuffer *kbuf);
+static unsigned int update_pointers(struct kbuffer *kbuf);
+
 /**
  * kbuffer_refresh - update the meta data from the subbuffer
  * @kbuf; The kbuffer to update
@@ -309,13 +312,24 @@ void kbuffer_free(struct kbuffer *kbuf)
 int kbuffer_refresh(struct kbuffer *kbuf)
 {
 	unsigned long long flags;
+	unsigned int old_size;
 
 	if (!kbuf || !kbuf->subbuffer)
 		return -1;
 
+	old_size = kbuf->size;
+
 	flags = read_long(kbuf, kbuf->subbuffer + 8);
 	kbuf->size = (unsigned int)flags & COMMIT_MASK;
 
+	/* Update next to be the next element */
+	if (kbuf->size != old_size && kbuf->curr == old_size) {
+		if (kbuf->flags & KBUFFER_FL_OLD_FORMAT)
+			old_update_pointers(kbuf);
+		else
+			update_pointers(kbuf);
+	}
+
 	return 0;
 }
 
-- 
2.42.0

