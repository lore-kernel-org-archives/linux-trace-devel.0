Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA4B364AB
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBC9C433C8;
	Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLq3E-000000013uv-2W8j;
	Fri, 05 Jan 2024 14:40:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtraceevent Documentation: Fix tep_kbuffer() prototype
Date: Fri,  5 Jan 2024 14:37:42 -0500
Message-ID: <20240105194015.253165-2-rostedt@goodmis.org>
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

The tep_kbuffer() prototype was missing from its man page and was broken
in the libtraceevent top man page.

Link: https://lore.kernel.org/linux-trace-devel/20231229121450.7a19ccaa@gandalf.local.home

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

