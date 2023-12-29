Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969C912B68
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 17:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED43C433C8
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 17:13:58 +0000 (UTC)
Date: Fri, 29 Dec 2023 12:14:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent Documentation: Fix tep_kbuffer() prototype
Message-ID: <20231229121450.7a19ccaa@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tep_kbuffer() prototype was missing from its man page and was broken
in the libtraceevent top man page.

Fixes: 6e637fba207d4 ("libtraceevent: Rename kbuffer_create() to tep_kbuffer()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-handle.txt | 1 +
 Documentation/libtraceevent.txt        | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-handle.txt b/Documentation/libtraceevent-handle.txt
index 64528ebc3433..fd55712db705 100644
--- a/Documentation/libtraceevent-handle.txt
+++ b/Documentation/libtraceevent-handle.txt
@@ -17,6 +17,7 @@ void *tep_free*(struct tep_handle pass:[*]_tep_);
 void *tep_ref*(struct tep_handle pass:[*]_tep_);
 void *tep_unref*(struct tep_handle pass:[*]_tep_);
 int *tep_get_ref*(struct tep_handle pass:[*]_tep_);
+struct kbuffer pass:[*]*tep_kbuffer*(struct tep_handle pass:[*]_tep_);
 --
 
 DESCRIPTION
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 26e3ad2523db..9e7777283c52 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -33,7 +33,7 @@ Management of tep handler data structure and access of its members:
 	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
 	bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
 	int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
-	struct kbuffer pass:[*]*tep_kbuffer*(struct tep_handle pass:[*]:_tep_);
+	struct kbuffer pass:[*]*tep_kbuffer*(struct tep_handle pass:[*]_tep_);
 
 Register / unregister APIs:
 	int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
-- 
2.42.0

