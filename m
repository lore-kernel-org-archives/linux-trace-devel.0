Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA78155398
	for <linux-trace-devel@vger.kernel.org>; Thu,  7 Nov 2024 20:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731011366; cv=none; b=aavy2JfWRBQT03T1KLcYfnt8TpDTT77S/rn0ui99rvOg5sSJEbKTdKCz+a/Gk0RGyZFChyHyOcGNgeEv/qAl4bMeP554a5jRXAKHEbZsNpFQ9K+QDYOiLF+D2GwGu9u/ZNkBIcleuA19gGVPca3Rtrq7is2iigr3pvkP3B1hseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731011366; c=relaxed/simple;
	bh=vy0ywimdykUxh1bN4hexkUZU1Du+tek7YganPAhWOjc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rysefjri0M7dzTD/ZdUBuG0YGn1wgGPFLufjrG3ZZ1OgC8UOsc/MvvLoBY7uEzu6Qw11KVoooDNxgpMTJ40DZe3t2U5LdxuuaGFdJGNOJqRNm9PfpogbO9y2add710mype4RsUZ+/7dmeclPfOwRlfMpS7ZGCh3l1yJ7eeXqSVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MjnbMfIZ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjnbMfIZ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37d4ddd7ac1so167858f8f.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Nov 2024 12:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731011362; x=1731616162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+E+UjM6BY4weP5JF9JQNXn/vfkFSg/Tyyw6LavaNWGE=;
        b=MjnbMfIZTNliczSUxFL8VGZnPUXI0MfdRLPcd7nzoFq3ERJAAOD8FKKS2g+jZhlq2+
         YfNCVPFIavgv7fp6JNrASecsDz7th/lHjURLOMU6s8RFkTJgP87k1NbS0G5BN/0OuiVP
         ymWaNXbSWebAO0ms2YX//o0oaZOi0SjMFj52rwfNJXdMFmJIW2lRj+pDJrgq11fxTuTP
         Y/a2YI++DG+TWiQ7LcebbDrNQPReeDZoEvytMCjeAWcE2a0O5OD2uIXN0Vaqs9ST0nT6
         XkJFTU1S+UTDnZpLdhz34qaBHSsyS140xjBqjawqtjY6cNTEWgXgSGs2HDFIwPVWdSud
         fVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731011362; x=1731616162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+E+UjM6BY4weP5JF9JQNXn/vfkFSg/Tyyw6LavaNWGE=;
        b=HvDcemcZ86tw6U5xjODZBWz6nUazJtS6I18tVirwRaI6CA7p/Xn6mEVunu4+9adFx7
         aReup9YFtmkjikIftzGXA6sFerAUaK5wQMFW/IUPNRPQt+zeClAwMuuBm/c+5xVRh/cB
         1fIRzRKRA+z+1L6gLHmiKUdfODqQAB7PYtgQLoATnY88IfnsLa2Gg+VUx1FZBAGaWC0+
         Hmbb7KqJ/1b7PPIlua1JZ01g+DtztDfS1fQCv795lxkfxUh9EpqmmPxPtsbKJ46U/AiI
         +nddj2WAdz8Ulh7AnhyyiI8R35n655BrJe6UlL11Tf5jGqD5d8HzAwzTLuY2DLKv3NJu
         dMxQ==
X-Gm-Message-State: AOJu0YxRlcyqJuuRXfPNmaMuhSr8LDC0S6qlnLKWg/sk31VPttMqgnha
	kbPIcamZqX4KleGpOIQxfCyDgowxzpeRpQRgJzLJ5jaGxip8OOofhaYFyw==
X-Google-Smtp-Source: AGHT+IFE2N9gwzTza1byb5ig4X09dWkEnvjy9m1OEMXWtFvM3inu/zsWxivnsPXE0BEhq8acOacWkg==
X-Received: by 2002:a5d:59a2:0:b0:37c:ffdd:6d57 with SMTP id ffacd0b85a97d-381f1714462mr156135f8f.1.1731011362116;
        Thu, 07 Nov 2024 12:29:22 -0800 (PST)
Received: from localhost.localdomain ([88.97.160.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa74bab3sm72435305e9.43.2024.11.07.12.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 12:29:21 -0800 (PST)
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] libtraceevent: allow unsetting LIBTRACEEVENT_STATIC
Date: Thu,  7 Nov 2024 20:28:49 +0000
Message-Id: <20241107202849.340335-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We also use the unit tests as a final test of the built shared library.
With this change, we can do:
LIBTRACEEVENT_STATIC= LIBS=-ltraceevent make test && ./utest/trace-utest
and that will build and execute the unit tests with libtraceevent.so instead
of the static library.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 5f3e372..0afaef0 100644
--- a/Makefile
+++ b/Makefile
@@ -114,7 +114,7 @@ EXTRAVERSION	= $(EP_EXTRAVERSION)
 OBJ		= $@
 N		=
 
-LIBTRACEEVENT_STATIC = $(bdir)/libtraceevent.a
+LIBTRACEEVENT_STATIC ?= $(bdir)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(bdir)/libtraceevent.so.$(EVENT_PARSE_VERSION)
 
 EP_HEADERS_DIR = $(src)/include/traceevent
-- 
2.39.2

