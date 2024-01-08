Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C74537F7
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 16:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C86C433C8;
	Mon,  8 Jan 2024 16:27:57 +0000 (UTC)
Date: Mon, 8 Jan 2024 11:28:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] kbuffer: Update kbuf->next in kbuffer_refresh()
Message-ID: <20240108112853.2574015e@gandalf.local.home>
In-Reply-To: <ZZvYYY5MI8l803Ad@google.com>
References: <20240105194015.253165-1-rostedt@goodmis.org>
	<20240105194015.253165-4-rostedt@goodmis.org>
	<ZZhuKFAkDHRLHlwt@google.com>
	<ZZvYYY5MI8l803Ad@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 8 Jan 2024 11:11:29 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Yeah it seems that the update_pointers() is not enough. 
> 
> kbuffer_next_event(kbuf, NULL) will make sure curr is also up to date and will
> do the update until an event type we can read. With that change I don't see any
> spurious "mmiotrace_rw" on the output.


Ah you're right. Try this.

-- Steve

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 1e1d168..5651797 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -180,6 +180,7 @@ static int calc_index(struct kbuffer *kbuf, void *ptr)
 	return (unsigned long)ptr - (unsigned long)kbuf->data;
 }
 
+static int next_event(struct kbuffer *kbuf);
 static int __next_event(struct kbuffer *kbuf);
 
 /*
@@ -323,12 +324,8 @@ int kbuffer_refresh(struct kbuffer *kbuf)
 	kbuf->size = (unsigned int)flags & COMMIT_MASK;
 
 	/* Update next to be the next element */
-	if (kbuf->size != old_size && kbuf->curr == old_size) {
-		if (kbuf->flags & KBUFFER_FL_OLD_FORMAT)
-			old_update_pointers(kbuf);
-		else
-			update_pointers(kbuf);
-	}
+	if (kbuf->size != old_size && kbuf->curr == kbuf->next)
+		next_event(kbuf);
 
 	return 0;
 }
