Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46760369208
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770157705; cv=none; b=TYhxbBItQkdd4ND68khYh1FXTF+rLVczsQ4eNbbXnUTxs2PhlAeNLT6qpsBjvFjP5F2gvEu3sue3OEpX56jV7oA+Sl0xLk9PNhzjy5Gn2N+II9qGh/yZdE1M6lWq9Cfw41pKQoa4rp/8jCJPLbVMYE/HB7P3ZWXv7MQ/1g8DU2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770157705; c=relaxed/simple;
	bh=MSBCkgQlcpMhY9zmIYr0ly84LU3Lf8QdWwdFnbbLdQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NKoTAKhNMJ+CscxIZ1+FiD4gT8e4T1//yRC/1krXbVTsTgVXNEmBShLO3HOdkwc5aRP1L/1dQWKH1TBrVGAZELpr3kEQfbLd9qHVVkoPZ1zDpUth0UU8ofkshCJUR2PFF+MgpukK6QPHhcn5LmYRhXkSmXSBTh6klMZIZV0XmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BA8C116D0;
	Tue,  3 Feb 2026 22:28:24 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnOtC-00000008qzl-1zTA;
	Tue, 03 Feb 2026 17:28:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/2] libtraceevent: Add way to print function prototype
Date: Tue,  3 Feb 2026 17:27:25 -0500
Message-ID: <20260203222853.2110187-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In order to have trace-printk add showing of a function's prototype, add a
new function  that can use BTF to show the functions arguments:

  tep_btf_list_args()

Changes since v1: https://lore.kernel.org/all/20260120201543.460979-1-rostedt@goodmis.org/

- Fixed whitespace issue

Steven Rostedt (Google) (2):
  libtraceevent: Split out btf func init code from tep_btf_print_args()
  libtraceevent: Add tep_btf_list_args()

 Documentation/libtraceevent-btf-proto.txt | 124 ++++++++++++
 Documentation/libtraceevent.txt           |   1 +
 include/traceevent/event-parse.h          |   1 +
 src/trace-btf.c                           | 221 +++++++++++++++++++---
 4 files changed, 320 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/libtraceevent-btf-proto.txt

-- 
2.51.0

