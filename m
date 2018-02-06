Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35296 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbeBFIth (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:37 -0500
Received: by mail-pf0-f195.google.com with SMTP id y9so316208pfl.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:37 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 15/24] trace-cmd: Move version.h in include/
Date: Tue,  6 Feb 2018 10:48:57 +0200
Message-Id: <20180206084906.9854-16-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This trivial patch just moves the only header file remained in project's root
directory to the include/ directory, common for all of the trace-cmd's
sub-projects.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 version.h => include/version.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename version.h => include/version.h (100%)

diff --git a/version.h b/include/version.h
similarity index 100%
rename from version.h
rename to include/version.h
-- 
2.14.1
