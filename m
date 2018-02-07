Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754002AbeBGTgJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 14:36:09 -0500
Date: Wed, 7 Feb 2018 14:36:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH v2 13/24] trace-cmd: Move python-related files in
 python/
Message-ID: <20180207143606.5db63242@gandalf.local.home>
In-Reply-To: <20180207142238.74d12ec3@gandalf.local.home>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
        <20180206084906.9854-14-vladislav.valtchev@gmail.com>
        <20180207142238.74d12ec3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 7 Feb 2018 14:22:38 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> I'm looking at why this breaks install, but I found another concern.

Here's the fix, I'll fold it into your patch.

-- Steve

diff --git a/Makefile b/Makefile
index 9544d84..89bec15 100644
--- a/Makefile
+++ b/Makefile
@@ -86,6 +86,7 @@ export PLUGIN_DIR
 export PYTHON_DIR
 export PYTHON_DIR_SQ
 export plugin_dir_SQ
+export python_dir_SQ
 export var_dir
 
 # copy a bit from Linux kbuild
