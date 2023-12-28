Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D6910787
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D459DC433C9;
	Thu, 28 Dec 2023 20:36:25 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx7z-00000000Dsa-2JUd;
	Thu, 28 Dec 2023 15:37:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 01/23] libtracefs Documentation: Fix tracefs_event_file_exists() issues
Date: Thu, 28 Dec 2023 15:35:23 -0500
Message-ID: <20231228203714.53294-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228203714.53294-1-rostedt@goodmis.org>
References: <20231228203714.53294-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In the man pages, tracefs_event_file_exists() is missing a semicolon and in
the main man page, it's missing it's last parameter too.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events-file.txt | 3 +--
 Documentation/libtracefs.txt             | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-events-file.txt b/Documentation/libtracefs-events-file.txt
index 425eebd82e8d..1a298b3bbdaa 100644
--- a/Documentation/libtracefs-events-file.txt
+++ b/Documentation/libtracefs-events-file.txt
@@ -23,8 +23,7 @@ int *tracefs_event_file_append*(struct tracefs_instance pass:[*]_instance_, cons
 int *tracefs_event_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
 			     const char pass:[*]_file_);
 bool *tracefs_event_file_exists*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
-			       const char pass:[*]_file_)
-
+			       const char pass:[*]_file_);
 --
 
 DESCRIPTION
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 787636a32965..850118302ab2 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -87,6 +87,7 @@ Trace events:
 	int *tracefs_event_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
 			     const char pass:[*]_file_);
 	bool *tracefs_event_file_exists*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			       const char pass:[*]_file_);
 
 Event filters:
 	int *tracefs_filter_string_append*(struct tep_event pass:[*]_event_, char pass:[**]_filter_,
-- 
2.42.0

