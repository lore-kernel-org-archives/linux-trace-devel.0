Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF559482D4
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708617790; cv=none; b=CHqRefpCDYZUOx88HdqlsJZHBzldwRotAeCHYgSR7lexR1fnZMVV1iPfXi0DzG1jofmiwS06yy+FFj8sjankq0dZ/f/RceRH4lTidQK8BUP7aTXKf2vC74YKlStfy9AJ60ocfiLLkX+wK908azbKPU4Thu1X2NCNoFDIjjzNx1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708617790; c=relaxed/simple;
	bh=13dkWk/Jpekt3iOqfXeR/FQos/O4oChBn5I8qFzNup0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=YjwPbUA0EaefbgmJyZIMolYvCflSDvbZGIEpd2xD8UtUQiBnNuMHjkv/r+nZaqf1+kKxH/jCvewEkc+c/2Lvltf4varLuU6AyHANB04MbCjARLZ971q53R+6onLC/oP8OG/LqPfJ5ITBkl6RcmtiPurR3B7Ps4LADXAQ60g3sCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A08C433C7;
	Thu, 22 Feb 2024 16:03:10 +0000 (UTC)
Date: Thu, 22 Feb 2024 11:05:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Miko Larsson <mikoxyzzz@gmail.com>
Subject: [PATCH] libtracefs utest: Add PATH_MAX if it is not already defined
Message-ID: <20240222110500.47141873@gandalf.local.home>
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

In some setups PATH_MAX may not be defined (it is usually defined in
linux/limits.h), but we just use PATH_MAX as something to hold the paths
to the tracing files. In that case, just define it to 1024 if it's not
already defined.

Link: https://lore.kernel.org/linux-trace-devel/20240222-utest-fixes-v2-1-7b8ee8dca0b7@gmail.com/

Reported-by: Miko Larsson <mikoxyzzz@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 963fac70846d..07ecd3205716 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -26,6 +26,10 @@
 
 #define gettid() syscall(__NR_gettid)
 
+#ifndef PATH_MAX
+#define PATH_MAX 1024
+#endif
+
 #define TRACEFS_SUITE		"tracefs library"
 #define TEST_INSTANCE_NAME	"cunit_test_iter"
 #define TEST_TRACE_DIR		"/tmp/trace_utest.XXXXXX"
-- 
2.43.0

