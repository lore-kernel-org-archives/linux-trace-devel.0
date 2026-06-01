Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F20298CAB
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332803; cv=none; b=pv0KJPsm9DS8WH+IgjBT4NaKJoPbdjSAZx9g7ebljeuEaOzeAcoezhG5cJbVhSvHOEsFQ0VJCp4ZT/dqwxa1/f5pQsDwxAlt13edDIon5vogh/15H+ldKmUv5dWKnke9MmL1RGkJtXrZrvBKGEghVCG/KpqCKUyTkpZrM1qC96I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332803; c=relaxed/simple;
	bh=RdagXubcRWAEjl84jzbaylY/gV5ZGn1WHtEjRMH8Mv0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U5/yy6HBxz7KlE+qPuNXpLGWhe3aB3au0DH51TYXwe5dPf7P7jK//X5B8+AZZikRZoJsYhQDMTxzO+0zWn0/zIhepw55LesA7V8eJNgdMVBEBmdkj/RtOc/FgpIcm9I/fqoLUKQUOBtOg9rktfosL5cuyYt7hh8shUkAG98nT/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HBvRDNvQ; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HBvRDNvQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9K
	frbavQkoKNi+lbSQNbc5tJCfxGv7Z3WHIk9nXnkZw=; b=HBvRDNvQCNLbgIac99
	TyGTv3T9G0aFj3FCDw09ejzvQuBPtJxIbpiOA2TWaRPVhWRQfqzv8SlLHkCVnyXz
	jMasb0GYRtiJPgy/N7NXsTZ+oOlrUoYd+Sg4L1Z0yL3Xb2L/GkAwv32qN7tvPY66
	JsEx6g0XiZv+8txQOeUcIs5Wc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBXlKLquB1q+rd1Aw--.65291S2;
	Tue, 02 Jun 2026 00:53:00 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
	Emil Thorsoe <ethorsoe@tuxera.com>,
	Cao Ruichuang <create0818@163.com>
Subject: [PATCH v2 0/2] libtraceevent: Fix BTF utest host dependencies
Date: Tue,  2 Jun 2026 00:52:55 +0800
Message-Id: <20260601165257.57814-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXlKLquB1q+rd1Aw--.65291S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFy5Kw1UAr4Utr13Jw15CFg_yoW8GFy7pw
	45uw1YkF4DAay2vw4ayF17CrZIvanYyFW8J343Jw1fCr1UWF18JF1Fg3WDWrW8Grs5Xa43
	Za1jywn0kw18Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRLqXgUUUUU=
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC5wxLhGoduOwrYQAA3N

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

Changes since v1:
- In patch 1, fold the read_full() call into CU_TEST() so that
  future CUnit failure output reports the actual failing expression
  instead of only "ret == 0", as suggested by Steven.
- No code changes in patch 2.

Cao Ruichuang (2):
  libtraceevent utest: Handle short reads when reading BTF
  libtraceevent utest: Avoid host-specific getname_flags output

 utest/traceevent-utest.c | 52 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

-- 
2.39.5 (Apple Git-154)

