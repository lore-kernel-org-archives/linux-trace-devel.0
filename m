Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D22594BC
	for <linux-trace-devel@vger.kernel.org>; Sun, 29 Dec 2024 19:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735500278; cv=none; b=RT8r//FToQsgPGoere6cmeI7nqHHjCR0ZGjByg775UEPUlvfvXvPkYKf5VzQ0lkzSnteag7E+1XuPCwPkrJ/JmvbT8kiKn/7VmtFgD9cXlG9AtmzpbbS8yf5XRFJeq/TWVFxDlDPiX++vEi1sjJEG0hKwAa9i0qZC0NNa18SyRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735500278; c=relaxed/simple;
	bh=2vxO0jrSXy74OPV4+c81sJDHK9Q6Xsa4nrI/siYo9lI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kUChB/9xztFfaTDJfq3bT25Mq/TfkPkolw1QzzuCnomq+WI4nVhRmJhe/sbPgPjX2WYGAm2iCAwxCGd0ZTwTcl8ImPhr7dKzaBt2Ph0CbAPCRxCwPVFBGKHNsaaKXswBj7rk7uljgNJPoGKprrhlA97QYG8B7XNYIix0uRWIlP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ktkGOS7D; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktkGOS7D"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d41848901bso16605693a12.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 29 Dec 2024 11:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735500274; x=1736105074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7NymlND/9nhY+bsl15UXiWZDq+jNXFH83CODjL8LYUQ=;
        b=ktkGOS7DRQBjV2y5EYZ3uVt+qr5Pk/fSdDyxqx6r/opiggUJ7F0R0pdViJat3GmgSM
         oG7UROmTcHprbW2gozocap1O9FG1lLQIMV2feJmJKGPalle4xoEBfECTANeHAIHFXxCE
         hJdXydpF9a6oaBrn9D8GjHEH0SoMGlCqI0kFEFIysfihiOgA5N+8j1AZ+49lnUhmViPr
         yejU1o4PIu7Yes025AA7R+1YaebbvItNNXNewvPk0VrXCFeVFuKavOeUivvChKxqbFoq
         cFXzNUCm2LBkbud1WcBZkHI3mR5odAH81so5+Y9Byb7Ci+b06D/AGwkfzZgGvESessck
         wA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735500274; x=1736105074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NymlND/9nhY+bsl15UXiWZDq+jNXFH83CODjL8LYUQ=;
        b=hP8AxLfmraj7KqIFUTgnzOUiiQzOMY4ONNMmOdJbK4/JuwK29umpZWSKLJUoHfDXPR
         cfu2xqStgEi48FhzB606t03W5EW0Yl72fOEkvGxKeOOdQKUzZueDRVBZXZfWBrf7ObhP
         fDxwfyI7zWB24B11JfoEBjYU2CEvVjuZ5ylPFe1C4X7cf02hbNd9Ru23Ts/ZYJWFlcpx
         RR4JWZQulIK8OIsXJeYLIiEW1lWtm5jUjVY9ZQSv89zJSzQCS/ZEVF25tDgVQZ+j6XdA
         owVJImFemFtzLUziwJAOYZoZGAG2zmh3TQDstSm2cXkT6DVQrryqCdezPipKqGjznuSK
         Wtvg==
X-Gm-Message-State: AOJu0YwtxdGjMowNISH95sY5vluIFZ7x19i5L8l6QkV9oRPdBd2UuAEO
	QA23qcpPAtWQXiAzN++ktpRWywH8FjUzuAEF6Q0lq+Jiu4uoAoSBFAFs+EOj
X-Gm-Gg: ASbGnctHdRTCLw7OvHgwn227BqeRNyUzJV9H0Is3zUAdx+JuyzsZsrpM5WdYAf016a8
	qMLWUUVjkwOEsiKusmZB0djPqUTsiM8rht69AlYcxEDR+381QhNnl3pZESIHpScgRRqMfAJBNff
	LdaRQM/UN7vY12OfpRSUDZ0H6gof8MnS5yXrAlklnHqNy/tuMVMEvH8+GNpQvtgSyltsb6BJUNW
	8KL5hLOizWwdnJM3fboXs+4NjFfboF2PbUojR1j1IX7+fHDcJwxyKB+tHYD9zfG8Q==
X-Google-Smtp-Source: AGHT+IHD5dPmfFiXyottn7Bsjw+EXgiDH+vZ+FvWxiRJrrcNOFtPmbKYEAbqfI3gQscCBj1ROrvl1Q==
X-Received: by 2002:a05:6402:e05:b0:5d3:e58c:25e2 with SMTP id 4fb4d7f45d1cf-5d80238b2f5mr30609953a12.2.1735500274234;
        Sun, 29 Dec 2024 11:24:34 -0800 (PST)
Received: from localhost.home ([2a02:a03f:e6d8:fc01:121f:74ff:fe57:106])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80675a735sm13586686a12.10.2024.12.29.11.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 11:24:33 -0800 (PST)
From: Ruben Devos <devosruben6@gmail.com>
To: linux-trace-devel@vger.kernel.org,
	y.karadz@gmail.com
Cc: Ruben Devos <devosruben6@gmail.com>
Subject: [PATCH] kernelshark: Avoid nullptr deref in _graphFollowsChanged
Date: Sun, 29 Dec 2024 20:21:55 +0100
Message-ID: <20241229192155.33113-1-devosruben6@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In _graphFollowsChanged, _it will be null as long as the search function
is not used.
Use row instead to send a signal to the graph widget when toggling the
"Graph follows" checkbox to avoid a nullptr dereference / segfault.
This will also make sure the marker on the graph points to the correct
event when the user selects another event afer using the search
function.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219637
Signed-off-by: Ruben Devos <devosruben6@gmail.com>
---
 src/KsTraceViewer.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index d4bf5f1..6efba7d 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -311,7 +311,7 @@ void KsTraceViewer::_graphFollowsChanged(int state)
 
 	_graphFollows = (bool) state;
 	if (_graphFollows && row != KS_NO_ROW_SELECTED)
-		emit select(*_it); // Send a signal to the Graph widget.
+		emit select(row); // Send a signal to the Graph widget.
 }
 
 void KsTraceViewer::_search()
-- 
2.47.1

