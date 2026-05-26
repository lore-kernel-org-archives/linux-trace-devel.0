Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4DC3BB661
	for <linux-trace-devel@vger.kernel.org>; Tue, 26 May 2026 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779820976; cv=none; b=X80SZyG/+JjPQTeElunAFlFxBIBa8GCCybWOZ8sAAj0BRRYmZ+/cD/G3Xsn0U4fvMNcGx3dksRW42es/aCrTIXKWpX9bgS0O2cJi1hrd0F5hrzZ84t/RRvj6K78vORS/S0tcCy2Y6nrkxObjZVjKgvTGv59WN1aOoXbQ/LeUgfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779820976; c=relaxed/simple;
	bh=m6/CpBVrOzdhV+Z41xuRoRjSE1o9RrW4xzO98YTUxnU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eaiYxBRvf4VTXZmS9WtyCIWxroPveWoe2OG9ea1OmT13SlJ95Aitw6IPc9IoR+1HoT+LxB1YzxClq7RNfcewu93Hg9NJ4kesHb7HZTrBWnsvmqP4RMCcOiHyU1BexsLjbSAXsLBUYGsYjkzQPTsFHJfajvoaytyvpdUBQu+7CiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PikCR9XX; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PikCR9XX"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d7828221bso1030042f8f.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 May 2026 11:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779820974; x=1780425774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KMsfNdzYjVE9sPzRVuBPRuRlLZqnfUh3y41hBwszL5U=;
        b=PikCR9XXfTFhkUKZTmdVX+0dJ7IlYLw7ftzsJ8mm9T+wt/JFW1z8/uHfmMdYBpteMX
         UhzWivKXzs+nORLnL6LiRLz1K7gCR2Hllkvv/19DHcN3+TGBiM+GzI8xL4bgCvMZCHOJ
         ruzUOiNgKtaZSHPA+Sza8GF6zGClc+Qysf8a05zyv2pFDHdDktHkwFZndls7ZeBwCZgA
         vk8sryC29O6GaWvJOzvClu9gFDVFgpIjeGmjHt2J56egUpIQW6h/Zf8V7mM1ot5R1ovJ
         o79mY+yv6Zsr5JGNDivWLHUVYrMfKCbCrx9GSNeW7JYH/mPEofycSoxcUSUXZ6+DeEEM
         qmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779820974; x=1780425774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMsfNdzYjVE9sPzRVuBPRuRlLZqnfUh3y41hBwszL5U=;
        b=CIrZ2IzlrRKHKHvPOZI7pyTOPE65Rzp7TZv0luVAMr8i3SB4/uMaKaEVRnPrkWTmGV
         U39BVbQIRn/3kznXWV9bJo/XldT8BXFlGQfPxwQ8GCWWvIBb5uNvE9PuoZf0Nr8vDMW6
         hhcYzwNnIzZt5GEYKgBi/LtUSsNjqqyt+H0+Q5rtrZXGBJZNT/YxAQybAhNIrGgrTMPw
         icesmBDfgqNI/JF0NfDTNq1iactMlN1rEd+m3ke/Nk4h8Ko0mM+766gmoaZy4E38vGz3
         qQiIjLx25iOi6tmtOh/nK2ZxUGuoG6nsHHJxAYsZj2fhNcZaVFrfHGQcZU0JRiGxaxjY
         wjUg==
X-Gm-Message-State: AOJu0YxGzUHdcz5Sp+m9R3dlYFZCMNuZGIddTEmKuwf6OP8Z6K2dKz2I
	8ohMYPm1UC//98GoKMDzengkxWz5lt0wA551/9cJKaYFJ4gC1uV7KGT9H5YA7A==
X-Gm-Gg: Acq92OFJ+ujk218dR4kqLSTpTsQuwUaKKW6DI3uAUT8JR5MA69hkPlNf8jrsPLOyYWK
	f1YuOur4iHXjKJhOXF/1R7Z0GxjkQM68KdUzpxAQ6q9KUBVfdBYVZ8ITQb4G7k/+B1RRHdXq5wC
	8zEHwD+qXCVtKGXzLrlgY/K8mMnsqwq5aRysbocl0QDTN3fR/+qlvzZuE2OFHPAhDnmgNnX0dPr
	tebBz0SvEEmUL6YTpDhUPh1LRZ9hRKL/PBn4B5zIbXhJWqLJ8Ol9Hnz0NfMTRHR0nvMKA3Rc8WE
	M2JPLlx2XJTohpTBminw9Yb/OehHar6lvdQyak+7P7znwFJ+z9OLhP+HxEa9POz6feqm/PML14m
	8Uaesec5GKJdY0rNdF2DrZboFNYkgp9r9My/pj7xeXm9R4ZNSHV+ULa7a/NhRZDZT0OX/j5cExr
	DKiP7Xno61c2C860qhHBJA+n7od3J2hkur4g8=
X-Received: by 2002:a05:600c:6995:b0:48a:797f:24f8 with SMTP id 5b1f17b1804b1-4904224db27mr165130465e9.0.1779820973671;
        Tue, 26 May 2026 11:42:53 -0700 (PDT)
Received: from debian.home.arpa ([88.97.179.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5584b8sm142068f8f.11.2026.05.26.11.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 11:42:52 -0700 (PDT)
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] libtraceevent utest: exit test if mmap fails
Date: Tue, 26 May 2026 19:42:19 +0100
Message-Id: <20260526184219.408223-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CU_TEST() continues execution even if the test fails. It just records
that the test has failed and moves on.
So, when libtraceevent is built in a chroot, it can open
/sys/kernel/btf/vmlinux but fails in mmap stage and since CU_TEST()
does not stop so we get a segfault when tep_load_btf() tries to use
the mapped buffer.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 utest/traceevent-utest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index b62411c..547619d 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -397,6 +397,12 @@ static void test_btf_read(void)
 	CU_TEST(fstat(fd, &st) == 0);
 
 	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (buf == MAP_FAILED) {
+		printf("kernel has btf, but it might be a chroot and mmap has failed\n");
+		close(fd);
+		return;
+	}
+
 	CU_TEST(buf != MAP_FAILED);
 
 	CU_TEST(tep_load_btf(test_tep, buf, st.st_size) == 0);
-- 
2.39.5

