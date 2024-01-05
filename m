Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9828364A1
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF712C433CA;
	Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLq3E-000000013uy-2d3E;
	Fri, 05 Jan 2024 14:40:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] kbuffer: Add event if the buffer just fits in kbuffer_read_buffer()
Date: Fri,  5 Jan 2024 14:37:43 -0500
Message-ID: <20240105194015.253165-3-rostedt@goodmis.org>
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

If the buffer passed in is exactly the size needed to add an event, it will
not because it checks with:

  while (len > kbuf->next - save_curr) {

Instead of

  while (len >= kbuf->next - save_curr) {

Fixes: 05821189 ("kbuffer: Add kbuffer_read_buffer()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/kbuffer-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index d43fe5d972fd..4801d432c58c 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -995,7 +995,7 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 		/* Due to timestamps, we must save the current next to use */
 		last_next = kbuf->next;
 
-		while (len > kbuf->next - save_curr) {
+		while (len >= kbuf->next - save_curr) {
 			last_next = kbuf->next;
 			if (!kbuffer_next_event(kbuf, &ts))
 				break;
-- 
2.42.0

