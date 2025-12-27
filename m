Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C31494A8
	for <linux-trace-devel@vger.kernel.org>; Sat, 27 Dec 2025 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766844590; cv=none; b=kdm1XbxFgEVBnl0ThbGGIq3BLfVs6G0gupK35wLeV2OgUBTx7geSPrqSQg1OoF+Rc+9K3yAbB2/5M3cr0Q6yVuqT9YK+rAo3VzRX1tz97r14oX6iCKejg3WE4HFvKCPpKtNRIDgA+rS2sw70LvdI1+0lmdW6AM8Eyj2tKs3PAjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766844590; c=relaxed/simple;
	bh=Uk5tNrLZXId7j62PKoQXVhFqRxNkJzyx7pmi7FdxJ3M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mxL9TB91rvQudIbMgIheaGAw17tmUKSv7Cj7ZsA7l1x/0X4+oHmwualN4f1o3ptKhTwDP1RvwSOUu9IOND4PQVeqNtpfV7FxTH+F7JpJ4hGf0oVxkJqREv6cjN1eFqMph8mPDhsoec/eRTqG8ogXqFJdWAYsqNlcSBEdUGFnVRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYjP64zk; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYjP64zk"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a09a3bd9c5so70095425ad.3
        for <linux-trace-devel@vger.kernel.org>; Sat, 27 Dec 2025 06:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766844588; x=1767449388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UfZ/yJ6Xa6/JL2AQGK74TEZ3af+VVqekhx7FHOfzp+8=;
        b=PYjP64zkJ14MbRlIKlQ2Lmh0QDk1JNC9daEWkwv7RHnkt+unjGbeUQ9EzDYafavlbO
         RwKUQxuXs5aTT/EgOOF/cdEU6/zFs9hoKwi90PJyzf7VpxAbjeKuN7kW2OfGjDdquhiw
         NyFdpMzcBhjGxgvUiyooYKjeeJzCHIjLOJWnWDEmszVj/Z/yOrXjjU/on4AlzKSUhZMJ
         fLVU/oJtnjGqluvTTzLdRc8zYOQsKLpPBWHelZdKzDorIDiCtj4lXW8gV0m+pOS8g9o7
         OoaLbW9ZomlWKflc1h8enOYyh8bT2KpbLclNYw5IjDYp1Nqgjr/VNYAauVu65ddDO4j7
         gh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766844588; x=1767449388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UfZ/yJ6Xa6/JL2AQGK74TEZ3af+VVqekhx7FHOfzp+8=;
        b=fZkKHgONx+M32S/tz7Rh2oHiaQIiS8C6qWaQbnw/GuOgcSS9yl2MxUJeRmce7scjGZ
         r+boyyWwpA8vs/MUtMVWWZLnFg2VjNORKTvu4YoRF6Rjd9fSdijeh4D/DdWCjrt58hJH
         XnEeKYIATnk8B5YKA20BjxQa7jP3uXcTryf4UPEyY3FaJ0588J34Bx6AtpktIumXloeZ
         R7qwmHraeSwY+aWaKYAIKOhKdxdyhvTgS173Gt6AvT3pixH9ABGZVU+YIruwRV7C6pKM
         CzJp3XG2EOZSMTx6nO5frGXImgfJwj8w0MQuIwzk5oC77kZFO4m591yRRgCc3x5BOJjK
         W7Zg==
X-Gm-Message-State: AOJu0Yy/8yJBFHIspkpQce5rC0TqaJszDUSIOOd79+5RkXdDvlXzI3xG
	p9psGhulMp8ksumNEuq6nMPzNRKuGvvmbB25NL2Sv7qBQwJw5OsodeHGXggt54EQCs0Txg==
X-Gm-Gg: AY/fxX4rqs73VwQn36v+iaFCJNsCnqadxwSxnoS0LKQULYe45cyXTqCMkx42iApmV5R
	IhnfWB45CYoYQ/CTEvYHCYz2RxdKS3kJkLX0UMeDY1oLNpTyhT8K7cddF/wkAYtnBiYLHudaz/W
	cK0f68FMv/8AB249aPujiKTACBmHJvydEbLmNDEgznXWyMQPjHfLh9wH0xcCUtNp3gYMDDIIv5D
	h0FBTzELYHRJzNEuzZPqZq9ACrQCm4bdu70GiEKYbo+/7EinjelGrM/pYX0O9oe6LIViZA0OS/x
	IVatqGTyV4aesMAR3dcm746nL6fYah7VGSaVhbwNm4jhogsW2SwCT5doj1sTD0I2b2k7TjMMo1c
	urYYj24Dy4J5+R320tyWVv0WGGi/qkaMgy/2Y6dfjYYJrppZU8zOVfk314HHn/YTBU7e6/nIm2N
	egXp+wdG0LsgS9QRgnBGsGQnxAzxRx3qeGgVEQ
X-Google-Smtp-Source: AGHT+IFK3LwIYFAr5mYAYcefPoGPvsuTP/goKJ8u4a12ujChlvAtE566bretE0oudZaowHK6Dkgb6Q==
X-Received: by 2002:a17:902:ce0d:b0:295:1e50:e7cb with SMTP id d9443c01a7336-2a2f232c836mr286026955ad.23.1766844588359;
        Sat, 27 Dec 2025 06:09:48 -0800 (PST)
Received: from DESKTOP-J2JE76D.localdomain ([183.193.50.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82858sm228396365ad.29.2025.12.27.06.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Dec 2025 06:09:47 -0800 (PST)
From: Wenjun Huo <huowenjun.dev@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	Wenjun Huo <huowenjun.dev@gmail.com>
Subject: [PATCH 1/1] trace-cmd: remove obsolete tep_set_local_bigendian() call
Date: Sat, 27 Dec 2025 22:09:10 +0800
Message-ID: <20251227140910.2024-1-huowenjun.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tep_set_local_bigendian() call in tracecmd_alloc_fd() is obsolete
because tep_alloc() already initializes the host endianness. This was
a legacy from commit cd001f7b40f9d ("Add handler to pevent functions")
when pevent_alloc() did not initialize host_bigendian.

The removal has been functionally tested by recording a trace on an
x86 (little-endian) host and successfully reporting it on an s390x
(big-endian) virtual machine, confirming endianness conversion works
correctly without this line.

Signed-off-by: Wenjun Huo <huowenjun.dev@gmail.com>
---
 lib/trace-cmd/trace-input.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f2471c92..95a8de53 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4942,7 +4942,6 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->plugin_list = tcmd_load_plugins(handle->pevent, flags);
 
 	tep_set_file_bigendian(handle->pevent, buf[0]);
-	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
 
 	do_read_check(handle, buf, 1);
 	handle->long_size = buf[0];
-- 
2.43.0

