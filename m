Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CC232423
	for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jan 2025 05:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736918076; cv=none; b=hgMQ8b7nzKl9+rcz4NzppXkEi6Ad9pSq0cKNVtNvW/gmmKUPQriIi9ECMex48Eaz8aYzUtHHOLl5zeGX9spquxXcSoLWtt3+qJGfP74pW0PlqkwGz/7JDTCvL3CPJjKBaOOejZfQgl0/aeDW5M8M3qvZgEUsJnhSKSkCpGb2Fqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736918076; c=relaxed/simple;
	bh=xgNuj93MskH+Ds/B2D9WhmZLiT2RF1z+UfI+AJzs0d0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FditMxg5JuvsI2bkYxALRFZq0rGTSJjiZ26Y3hHYdz0Bfr8nt2PhnaEa61c5EQcRMR9wf7fyP+mKpLAxQs9d4/OReqWsyQJLi+/Ziy+mlya6awIpLKvx5Uao+4dechtnZqqhX6BjsEh4PlrqhKah+EsOud+Z8oXmAAA7xXad8AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Zzg9XOH7; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Zzg9XOH7"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2166022c5caso98426535ad.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jan 2025 21:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736918074; x=1737522874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3q6DAuNf2yYgkEPW3w1N2K/8/8FZRn2t8cA5HbTBdWw=;
        b=Zzg9XOH756TsHurj2UGs8H8mpP3LLwTGn1CnieMqt3hWdROaVFhJsy1ZN/7ZeMX/Wv
         ZHq99BUe5EHomYzfknxZaPC9cnicmNlabHY38Rc4VqW6E4jSksCVcDj60SawDE28Q8Uq
         PDTBaKYkKZY8wW0/J+KztTzvlz2UWr/H2KuSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736918074; x=1737522874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3q6DAuNf2yYgkEPW3w1N2K/8/8FZRn2t8cA5HbTBdWw=;
        b=j9JMKPczWGvDQIdA4fbevanx4zngpAJNleOpDrO3DCsxf+EUlkarafX9hBqgVNBEbb
         gNFNOWHv9HnyA7qcB0gaDU2axHlEM5Q5GKntUfgSL1cUKFz4w5YZY77GI9WfAZ4zXX42
         ibHCkkvx+JGPRROtJ5QjwFTeJUsp39r0tG13D7X3U4VWGx5XOX8a0a5joNWdLVdlqysB
         oxnr/4gISeox1Asylx45dRFfr52XoXEEQPVXcR5H9n+j60t0C7/QTyJkN6SL9UECYmHJ
         UtQX39Bv5OGTnUd//wSplHmZxmM9aeo0SGFj7/tHujo7AOji+vr8g5IiIk6gYHH2YCM4
         qaiA==
X-Gm-Message-State: AOJu0YwnNRo+8GDIV4uOvFFBmmUw1vNvCuK3tuu6pJF2um15GWL4XCcC
	XEusdDshoKC+GR/3bThw06T/3rGBfqgNz01DOqP5zdcVtRZMjtdXOOjF3t/zcRDU2UPpZS4M2QG
	yN8gE
X-Gm-Gg: ASbGncudDN0+IifLdTxc8gVyCmLVFvln5SkGUX2PvxGdjVtJpbgxCM9G869Tgjc9Kg+
	UfeUuU8kemtKAGiJr7polNaD4glpm/+wdff2L4of3j4C6+R5OjYsIHSV1OXratvHR2TeO5usga4
	z77UpTqgsbfgD46Z4ANl2on2PFNR8HaeByKCJIm4AY0BEbZ/r19c3YIh+EK7MOnVSnIlemC5vJ0
	wIQAjeuFczqgJgkp+qZrhQSS4mcVGplNsaC+GNRmCsKQqDsPLxv6wKZOnveYf3tvbUeJLwm5uWE
	uRUnDvJzLfNHeN+2DRtebzIszY08i8toTjCBXepY80LI1g==
X-Google-Smtp-Source: AGHT+IG4SMomtOQ6WJQxWVEDB/lNxloM10su5/aKZszVDhVqVH+qNNZQjW3cUKudePuqPql8ZTv/Nw==
X-Received: by 2002:a17:902:d2d2:b0:216:393b:23e0 with SMTP id d9443c01a7336-21a83fde4dbmr433467485ad.36.1736918074170;
        Tue, 14 Jan 2025 21:14:34 -0800 (PST)
Received: from keiichiw1.c.googlers.com.com (175.213.198.35.bc.googleusercontent.com. [35.198.213.175])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f25a583sm75789785ad.244.2025.01.14.21.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 21:14:33 -0800 (PST)
From: Keiichi Watanabe <keiichiw@chromium.org>
X-Google-Original-From: Keiichi Watanabe <keiichiw@google.com>
To: linux-trace-devel@vger.kernel.org
Cc: Keiichi Watanabe <keiichiw@google.com>
Subject: [PATCH] trace-cmd documentation: Fix typo in man of trace-cmd attach
Date: Wed, 15 Jan 2025 14:14:29 +0900
Message-ID: <20250115051429.3461122-1-keiichiw@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typo 'nesc' to 'nsec'.

Signed-off-by: Keiichi Watanabe <keiichiw@google.com>
---
 Documentation/trace-cmd/trace-cmd-attach.1.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-attach.1.txt b/Documentation/trace-cmd/trace-cmd-attach.1.txt
index 1edef4a1..17c75252 100644
--- a/Documentation/trace-cmd/trace-cmd-attach.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-attach.1.txt
@@ -82,7 +82,7 @@ Enable all events for tracing:
   # cat /sys/kernel/debug/kvm/63170-15/vcpu0/tsc-offset
  -27950965013436847
 
-  # trace-cmd record -C tsc2nesc -e kvm -e sched -e irq -e timer
+  # trace-cmd record -C tsc2nsec -e kvm -e sched -e irq -e timer
 
 # on guest:
 
-- 
2.48.0.rc2.279.g1de40edade-goog

