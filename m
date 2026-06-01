Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEB537187E
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 10:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780310296; cv=none; b=MzGLUHgiRJanH3Kac+1+KIIm8xtnOaa6vZJN+DS2hYiwl3bi0vNzAnN8RCVxQhgciU2sZac0+gYXFcIYskPhrKKcThLobT/ynTBod7HbL3KDNdfvUqZ6cvEBeHsOZ2ky8JClnPjOGYn43pDlq3B8juMVPjzUjc6Ur08zKeWCxcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780310296; c=relaxed/simple;
	bh=yLTtmG2eQQMY2YMXt1f14whHB6JjqV4kPaKE1MBPQNs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IinsfYhCt8nZvyHlw+Pqk9Zy2s3avghkAZtIQvMX1OK0uPAZ5L0R9zq/s6p7y3Gph2lKq/lEB2f+dEpGOCS8NstSbvqYt6mLQgB1ecBOli9+fdBel/qrDFDzd+UxDBmLkp0sBt0PLsasjj1oxxbPGGK3kjv2WMyn/vkbsOs52RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=qaNtEck8; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="qaNtEck8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=mc
	4B70bvmOn988C2qGlqA9wc8c2AN0UorO++T9Ooy5k=; b=qaNtEck8uECFm9B5Dy
	CJCd3ic9WM33F/VG4Gu436Ly9BRCoGjmo53HpU+J9Tc7AAmp+f04B3G3695VCdRh
	+FZqxmx2oydv2tAO0KAYrrU2U2EF5t9pv1uWxRrRSNeRKTMpjaVrQOQuNxhNEzFR
	wVPuMXaenTaP/UZIrdAF759h4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDnb0EAYR1qVFYYHQ--.59767S2;
	Mon, 01 Jun 2026 18:37:54 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
	Emil Thorsoe <ethorsoe@tuxera.com>,
	Cao Ruichuang <create0818@163.com>
Subject: [PATCH 0/2] libtraceevent: Fix BTF utest host dependencies
Date: Mon,  1 Jun 2026 18:37:48 +0800
Message-Id: <20260601103750.68805-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDnb0EAYR1qVFYYHQ--.59767S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw18Kry5JryfWFyfXrWfGrg_yoWkuFg_Kr
	WrZrykCw1I9FnxKF9xAF1xWasFya9rZw4Yqa4UAFyxJr1rAr4DAFZYywn5Wr48C342vFy2
	kr1Dtas7tr4agjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRiNBM7UUUUU==
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC5wI6c2odYQIS-AAA3W

Fix two independent host-dependent failures in the BTF utest.

The first patch handles short reads from /sys/kernel/btf/vmlinux after
mmap() fails. On a Rocky Linux 9.7 system, mmap() fails with ENODEV and a
single read() returns 4096 bytes from a 5150407-byte BTF file, while a read
loop returns the full file.

The second patch avoids failing the exact getname_flags() output check when
the host kernel BTF has extra arguments appended after the expected
arguments. On the same system, getname_flags() has a third parameter named
"empty", so tep_btf_print_args() correctly prints:

  getname_flags(filename=0x7ffe7d33f3d0, flags=0, empty=0x0)

Validation was done on x86_64 Rocky Linux 9.7, kernel
5.14.0-570.42.2.el9_6.x86_64:

  make -j$(nproc)
  make test
  ./utest/trace-utest -r traceevent

All commands completed successfully after this series.

Cao Ruichuang (2):
  libtraceevent utest: Handle short reads when reading BTF
  libtraceevent utest: Avoid host-specific getname_flags output

 utest/traceevent-utest.c | 53 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

-- 
2.39.5 (Apple Git-154)

