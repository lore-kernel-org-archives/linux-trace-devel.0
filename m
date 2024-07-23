Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947813B58D
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721772518; cv=none; b=JzZKux3KDHArzjITeMHzOUmad86EA5H4+A9s4ukeYkwk7nM3+qUOGIB8aFGG09CE9vFewoy0UUCqCIkwB6LoBqGI/Ft/WWPEYEq4QfxrI3zE5zkl8RL5pOzG/+MdkhlG66o5hwStPfp4aYrwhDJvDZDOSEywrhpOiDqeeX+w2/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721772518; c=relaxed/simple;
	bh=tD/afvBTPmN+xvUY4EFbwMtsr5WX6j0rLRiFy+c+xb8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CPU+tV8QXWgcdacGbG9NP0M8rJIevCBibmJwdrPjoFbEqOa0HWBnggAtkLQKGV3Z/HJZ5yTHIXfVEySODue4pVvWIJki++ydh/kLXuPI7g6/zaUnjlKwApbC5Pcvw+oacjPoXMqUPpfaqp+vXz7PWBtoBxp07Y7nRfkPreqMnYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1857C4AF0E;
	Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1sWNgk-000000023Fv-2nxC;
	Tue, 23 Jul 2024 18:08:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Enable ring buffer user space memory mapping
Date: Tue, 23 Jul 2024 18:07:22 -0400
Message-ID: <20240723220853.489058-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that the ring buffer memory mapping is officially part of the Linux
Kernel as of v6.10, enable it in the library.

Also add sample code to use it and make a fix in the self tests.

Steven Rostedt (Google) (3):
  libtracefs: Enable mmapped ring buffer
  libtracefs: Add cpu-map sample to trace mapped buffer
  libtracefs utest: Add better logic to cause missed events

 samples/Makefile      |  2 +
 samples/cpu-map.c     | 90 +++++++++++++++++++++++++++++++++++++++++++
 src/tracefs-mmap.c    | 10 ++---
 utest/tracefs-utest.c | 15 +++++++-
 4 files changed, 108 insertions(+), 9 deletions(-)
 create mode 100644 samples/cpu-map.c

-- 
2.43.0

