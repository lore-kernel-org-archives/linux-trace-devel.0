Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2193911C9
	for <linux-trace-devel@vger.kernel.org>; Sun, 31 May 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780247420; cv=none; b=Fj6RBWqXPvqaiC6obn2Q76dfvUaI+AFnjyLO3uY562zRzdlth4GJceHolRk8Y7o+wfWlt+uttPGb0Ro3juB7muGXfKObMCd+ohKM+ZPuAY49/iLuTkeGvyN0WvLkYD0Chog8kfrbmo0aeIzm6ETRwpbyJpF01y1jse5w5Rcksfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780247420; c=relaxed/simple;
	bh=Q3eqBlZVrsTQsWiPXY/tj/lae5lI7oFVxls9Ev1VlLI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q1o3PTyh9nbQZDtMC5tVhSId/0QnlIlyFlaMKruM0EFSoAIjEtCASe76BoVjXYnWgpokE9hlE6zh1uWilVxeJbCLAmRslCQghJbcHXZMnLQa77iiyPCBxyxlHxl7hJZI6zg0N/O1qj1HYAVvOGMNuD7IfAv7jux710SNx9uGcsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LviN2vFW; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LviN2vFW"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2bf20f6be6bso12802455ad.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 31 May 2026 10:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780247419; x=1780852219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CqJpbwtossSFW5neyJ87RipB4IcgiOFbuX2fMHVoKDA=;
        b=LviN2vFW0Vh2IdPSp86etBiNYRD3Jj8gfHQ+acMZCqBCpsm3rArijYf1hYtQ8s8l9y
         18/4qKLtKR8jndY+q+1jo0OzaouaiwdxXLg6CgsVeGLz1xrotle78b1ApyS5p4RJMpwK
         nvSKLNTBUQ2t2WCkdNpIx9Az3IPuA5dY9/tSYBVTQ3k47PIj76jh+W40czuYW5EflzzJ
         pDOhSci1kFbwWk/M+u+2YCUYVbpJgV70qJFT3KMzLAO0BLKVroQFyTGcFRecG6jXoRUc
         bDZa4FZ9eZQtE/O/3GAg4TYuvPXV7mrOyrWA7TtA+yL+IX3gbkln1TIEqJfstSrw7fzz
         SFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780247419; x=1780852219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CqJpbwtossSFW5neyJ87RipB4IcgiOFbuX2fMHVoKDA=;
        b=iKiwHGkhUUlM7nbqHWTunhWZj7ItfjLgHFurvnHA4JCGLJHAc1/9HZaeLjR4pDpoIL
         SjVr0NDXbeEV6r/VvIzQD/ddjx9sgUNHQ5B34n6PIV7Fz5xljStXqPv30SSf3c0SVo0F
         +X0EJu67T1EesLR2yWvtDBcVR9XNH8/PNLvvaU7CiQtpAMIetH7Evs6nOhsO9e4lTeg5
         oD+F5c0fdpwNfisInmtycgkM//OQouiHlpitWnFnb2G0WeYoIJHdu7p3OeudCdt/9imd
         a3YwOcAZ7IcovD6G8dM4ian+mSyvl46roTaoXrbrcpysX4XM0xyXv2dMLyvPQM4yFw10
         1MyA==
X-Forwarded-Encrypted: i=1; AFNElJ9diM3zBM7WzMWzUNt52NUl1f4iDn17whQWTqh16UyK2SnUnfa7QvsZu6evocIFiLD3fDMsKRpiJIKVKeLPvpRC0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEmY9rrM0grxk83N+eKfB4hh62W1BC3wkS/WQTtKShufvPt3O8
	6InuvdriNeMwHnn709FjPYsWmk9BT2SRC08W9DbtVTJFcKtBv7YUYu5IQyr5Zny43fA=
X-Gm-Gg: Acq92OE6Mj3UAbK7up2TtpEWx3xpGrwbEZU9Vwa2fQ63o4WaXoUEhbPJ9CENG5sX3RH
	m5DyoNEhYtm4vke4MHHYRpu4ubtRcyMjuaXA7QircyxF+K4n1c8hyxMiYva59tj0t7CPScibDPA
	l2RLzgA+DdvrTVz0HNV9KYFUJ59OwX6qBiYVWRM3QYLOfqzsgmhCQD/QnXOR4idg5uisgTzwGiN
	VOUfIcNaEnOu1X4pN0mqyoD2BJ1DasYVT2x3ks3S5yhsMGcI8DEPEbVXdF6B9rn+QUu/r8eeWwf
	1Yi1kMIpNi3Q3l7OgDlhA69QM19oeqCMifzSC+TxXTwu1460Erq/g2QIDRdptJtuO3bp1y5ANPM
	Wy8ig6BSqAhwKSCk1V6XJa9O2lFE9ZscPF/uiUjETYSXNs+eVjpFgt+rpxN7zPbDW659qPsBbed
	KdWm0dCr9TOFeFnq30mal3t4sBqSJqBgWedqQo3JhXCVo=
X-Received: by 2002:a17:903:986:b0:2b4:59bf:5728 with SMTP id d9443c01a7336-2bf3682a21bmr82919535ad.25.1780247418899;
        Sun, 31 May 2026 10:10:18 -0700 (PDT)
Received: from ubuntu24.lan ([14.219.52.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e71cbsm78487495ad.15.2026.05.31.10.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 10:10:18 -0700 (PDT)
From: Yiyang Chen <cyyzero16@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-devel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: tracepoints expose s_dev of kernel-internal superblocks -- no generic resolution interface
Date: Mon,  1 Jun 2026 01:10:13 +0800
Message-ID: <20260531171013.289131-1-cyyzero16@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

While tracing page cache activity via mm_filemap_add_to_page_cache, I
noticed s_dev values that do not appear in /proc/*/mountinfo:

  mm_filemap_add_to_page_cache: dev 0:18 ino dea89 pfn=0x13ba00 ofs=0 order=9

Using a kernel module to enumerate all active superblocks, I confirmed
this is the hugetlbfs internal mount created by hugetlbfs_init() ->
kern_mount().  The actual s_dev value is dynamically allocated via
get_anon_bdev() and varies across systems (0:18 on my test machine).
Because kern_mount() attaches the mount to MNT_NS_INTERNAL, it is
invisible to all mount namespaces.

Each internal filesystem requires its own trick to discover the
s_dev -> fs_type mapping:

  - shmem:      create a memfd, call fstatfs() -> TMPFS_MAGIC
  - bdev:       open a block device, call fstatfs()
  - hugetlbfs: memfd_create(MFD_HUGETLB) creates a file
    on the internal mount itself, so fstat() gives s_dev and
    fstatfs() returns HUGETLBFS_MAGIC

None of these are a general, authoritative interface -- each requires
filesystem-specific knowledge of which object to create and which
syscall to call.

The question is: should there be a single stable interface that exposes
the s_dev -> fs_type mapping for all active superblocks, including
internal ones? Here are some options:

  - Add fs_type to the affected tracepoints.
  - Provide a generic interface (BPF iterator, /proc, /sys) that
    exposes s_dev + fs_type for all active superblocks including
    internal ones.


Reproduce steps:

s_dev is dynamically allocated via get_anon_bdev(), values vary.

--- test_hugetlb_sdev.c ---
#include <sys/mman.h>
#include <string.h>
int main(void) {
    void *p = mmap(NULL, 2<<20, PROT_READ|PROT_WRITE,
                   MAP_SHARED|MAP_ANONYMOUS|MAP_HUGETLB, -1, 0);
    if (p == MAP_FAILED) return 1;
    memset(p, 0, 2<<20);
    munmap(p, 2<<20);
    return 0;
}

  gcc -o test_hugetlb_sdev test_hugetlb_sdev.c
  # precondition:
  cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages   # must be > 0

--- trace script (run with sudo) ---
  TP=/sys/kernel/tracing
  DEVS=$(awk '{print $3}' /proc/self/mountinfo | sort -u)

  echo 1 > $TP/events/filemap/mm_filemap_add_to_page_cache/enable
  echo 1 > $TP/events/hugetlbfs/hugetlbfs_alloc_inode/enable
  echo > $TP/trace

  ./test_hugetlb_sdev
  sleep 1

  echo "=== s_dev from tracepoint, NOT in mountinfo ==="
  # filemap uses "dev X:Y", hugetlbfs uses "dev X,Y"
  grep -v '^#' $TP/trace | grep -oP 'dev[= ]\K\d+[:,]\d+' | tr ',' ':' | sort -u \
      | while read d; do echo "$DEVS" | grep -qx "$d" || echo "  $d"; done

  echo 0 > $TP/events/filemap/enable
  echo 0 > $TP/events/hugetlbfs/enable
  echo > $TP/trace


You will see hugetlbfs s_dev which is not present in any mountinfo.


Thanks.
