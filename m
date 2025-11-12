Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B07332BF20
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762958964; cv=none; b=XUbDL8WHkxAgoNR8NtPtanjQ47RfhAYuKhz6oy1Jvh0Q7RHmjLjF8DOF1ZuHX8NKytKtvVnbr+U0LbPYOPyEaRazJC78MpNIFoyeKepwzBeI6POwyJ+tQW7JXMVhE2waS+NT2jZIYPchBN0JeiE9XoAb/vyYAxjj1Z4jXXlRXxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762958964; c=relaxed/simple;
	bh=5oUhkkVY9Ur0AqTA9rZnSgV/OSG0mzMgWltH5E47d/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eW2npjFMTbaMyIthnl9EJtdsTr5iekE9a8BXr5ISAcmnXvmoCSls7TbcH3fyJp+V01k2QeRPsSYL8V6drNCJCgdVZQMxUJOlZqZfr1vbMnVlIHRreGX/0kPEWWCPhK8xPPB+zfze9L8Fp+YOeRgEpTgGIhKMR6/YcxslcyhDgvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E6FC19423;
	Wed, 12 Nov 2025 14:49:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJCAD-000000017qc-15NO;
	Wed, 12 Nov 2025 09:49:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Metin Kaya <metin.kaya@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/2] libtraceevent: Fix static library to hide hidden  functions
Date: Wed, 12 Nov 2025 09:45:05 -0500
Message-ID: <20251112144912.268258-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the static library uses the objects directly to be created, it makes
all the hidden functions visible to applications that link to it.

To fix this, create a helper function in the Makefile (redefine_local) that
will search for all the global functions within the shared library, and if
they do not start with "tep_", they are renamed to start with "_tep_local_".
This will keep these function from colliding with the namespace of
applications that may link to the static library.

Changes since v1: https://lore.kernel.org/all/20250814144710.6c3458d4@gandalf.local.home/

- Instead of playing tricks to what to add to the static library, just
  change the static library directly.

- Modified the meson build to have this as well.

Steven Rostedt (Google) (2):
  libtraceevent: Have static library to hide hidden functions
  libtraceevent: Have meson build rename hidden global functions

 Makefile.meson          |  15 +-
 scripts/utils.mk        |   5 +
 src/Makefile            |   8 +-
 src/event-parse-api.c   |   6 +-
 src/event-parse-local.h |  24 ++--
 src/event-parse.c       | 298 ++++++++++++++++++++--------------------
 src/event-plugin.c      |   2 +-
 src/parse-filter.c      |  22 +--
 8 files changed, 200 insertions(+), 180 deletions(-)

-- 
2.51.0

