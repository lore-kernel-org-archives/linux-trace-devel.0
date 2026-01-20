Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C82E37F739
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Jan 2026 20:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768940123; cv=none; b=mwxxtbXtruaSe8FGGTQqIg2XtM8L0un5r1n5MZpxLV6WYpUGjhbW+THkAZH8Ze+kTFKQD6X+9YzyUtQyOjptlkKLi9kZSR1YBHIHntMfVTJabwtXVKAKyt+KvMHLgrUq6TaLsFXfAMmbczyTjYpXWQ7bLRdQrUNKVxPqPZGdF/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768940123; c=relaxed/simple;
	bh=ePV/w2xWDTzMPKbekI9hMJVU2DsqxPwrD+j8SS50SvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LlpUggUwrhIQRVsU2SkUt0pXsDcuUZxaAETUfFhUV3RMiasftFoddwEL2Xm1tavOTkaBteKcE0IEFNm8ROkj9GYqkQmMB/IvK9TUW/0u2uanATlkLHrRN/KdBWHNMrdxNCSkqNF2lZ/HzKFnOevo5WKGq8Fh+NXylVYbYR9KQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58051C19422;
	Tue, 20 Jan 2026 20:15:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1viI8f-00000001vwJ-1NbR;
	Tue, 20 Jan 2026 15:15:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceevent: Add way to print function prototype
Date: Tue, 20 Jan 2026 15:13:35 -0500
Message-ID: <20260120201543.460979-1-rostedt@goodmis.org>
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

