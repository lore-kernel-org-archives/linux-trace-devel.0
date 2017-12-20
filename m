Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35247 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755918AbdLTSIT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:19 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 15/18] trace-cmd: Move version.h in include/
Date: Wed, 20 Dec 2017 20:07:45 +0200
Message-Id: <20171220180748.17273-16-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
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
