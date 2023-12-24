Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76B5D298
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841F1C433CB;
	Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rHTzL-00000004VxK-3RTq;
	Sun, 24 Dec 2023 14:18:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/6] libtraceevent: Fix tep_kbuffer() to have kbuf assign long_size
Date: Sun, 24 Dec 2023 14:15:59 -0500
Message-ID: <20231224191813.1076074-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231224191813.1076074-1-rostedt@goodmis.org>
References: <20231224191813.1076074-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the tep handle that returns the kbuf from tep_kbuffer() did not have its
long_size initialized, neither will the kbuffer it returns. This can cause
inconsistent results. Default the long_size to the "commit" size of the header
page as that should also be the size of long.

Fixes: 21ba6336 ("libtraceevent: Add kbuffer_create()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/parse-utils.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/parse-utils.c b/src/parse-utils.c
index 9c38e1e644d7..b434e24e44df 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -137,6 +137,11 @@ struct kbuffer *tep_kbuffer(struct tep_handle *tep)
 	int long_size;
 
 	long_size = tep_get_long_size(tep);
+
+	/* If the long_size is not set, then use the commit size */
+	if (!long_size)
+		long_size = tep_get_header_page_size(tep);
+
 	if (long_size == 8)
 		long_size = KBUFFER_LSIZE_8;
 	else
-- 
2.42.0

