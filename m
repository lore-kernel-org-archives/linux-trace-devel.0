Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A243731AF3B
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Mar 2026 06:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772432402; cv=none; b=ulG/zVaJMhJmdbKrVznn9uxJ0flw1NSf/43aPESWadmjzIGphItRwnc0GGtMdpSCVV1+CSQWd6PWC2OORWT5r7zlFWt4pMQ19F0qBJaDRbQwjYvsMrF19Go6/2bCJwwQQ3UK35opiMi7zsMn3JkrOciPrxQAmHgdf96o/EhQT/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772432402; c=relaxed/simple;
	bh=9L2CJvXtGIPSowN59rKUdbGInOJuHm2IIVuNY9fiirE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ITWTb2oROcEjGghEISkzPx0q/1nUJYAKJUPCffX1iQ7+8NbViMojHe5s4yDv7vhIsiahN8F8FXQwtohrVmfyCZe0cw12c3Icn8H1RKNSKudSZL5k67bgIUey6S3689p76LqskgZtonxtMPdJSCWHGsV9/RDJNSkEQGK2RzP35Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=io3/fpYz; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="io3/fpYz"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2ba895adfeaso3441223eec.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 01 Mar 2026 22:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772432398; x=1773037198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pyApFpN+LFjT689OTsmyfpRwK642HgLJ1Y/I/9AgjuM=;
        b=io3/fpYzdhfE6ww1NZT5pnGUT8C5PinfBgPW9Swgl8Ffj22QdxqiBwnFeFeCjUUH1+
         Wey35ycsTKQU4PciVI7+CdLfXe1Ak1Uby/Fdjkc0uDWKAR6BqaL1maDTm9lq9pl2XhuI
         ZJHCOo/V3XVy6sYBIOMBoai++TY6lmeSbXcyhhl67kZU5GtZQBZi0djPcrk8xWF7xpMX
         pfyLQb0g7QIgGaCJJBqtJkhFBXpL4Igz6yNwQ1+WcQcnPE/yDPKb4RLLRWfPHamQXNh+
         BxBtH+Kofx+dseUaZ4+3uL/OD0CU9H9yG4XGTTXL0ftUhp6UsE2lG32tD6kifufOWxgd
         RK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772432398; x=1773037198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pyApFpN+LFjT689OTsmyfpRwK642HgLJ1Y/I/9AgjuM=;
        b=bsamuNhGQWtXjidI+B+GiamWicG37H3c8bNchVCfUPALCJkd1VxuwdKd0OeCKMowYt
         9kdiqGEQ+J1eLVUYMO/3+adZJAEfsY0+Z8cbXSVpDWawU0TbU2hDdTJVPAigjMKGtEma
         n6mReejABl9TUC4+c+KHuUip3YMCyLdxfbqrtRwZHAFIDnJi0EyHhOhf4ZmJ/yptZmTI
         T8H9Qix5/BVuesU1sfvpPSaPWpjpXGiSITkvSf+tcPYpgJDmt8z4k9ud0Bl/9HM3sgKp
         hHrPtXH2NSLCk00KSxsBvVNdVRkCRce9vLJc82S+nlSKKLqkCIxDDYDHc0DV/UcGIMww
         MCiA==
X-Forwarded-Encrypted: i=1; AJvYcCWPkPa/xu4AeNF4IWdgtGcN/dvb6KvfXv+b1kVOxXS/vUQicoGb1E+lrHyUdQJuxtLeBDrc3ocG4SO5OFd5LI7oOw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzp8dH/NAZWepmvsOLvjxXsxtWquSSlaP1BQvSH8QyLJSHv/Xh
	J+IGHyeLLcXJS3sYZW/9JluCY78HZVHIOjIhEZPRKSoY3ekEJj77fpQ+
X-Gm-Gg: ATEYQzzDY68YpGKQLfalaZE3Lr+hKMkYrD6Sm4Hc8wcKvQGuYsr+4kuO1Iil0F86sg6
	P9Pt0e3Rd9tXqg6cecuL+wHlYP1QxWglXzHYWmfqXLINTQN1v2imHT+VmpRnJYeSZMSTdq0dXp4
	IFIwCzZSYJ/clm4sfpaWtVLdWInU9xomzzju7YHz1bKR2xF/waA7yeCWLgQZ6hslW79ycmAEmml
	/BYWZ13dnIWRcjgh5915Q+MvWnQUp3q3KRBPfUI9+wS/6RW2dZeSX29FPs5ypiKM2ef0Qp96HvE
	Aq4gyxEtc31+5Qm0gCYQ0EfJa65xoZ+qBHcPgOx7inZWz4vlEYzqJ9dgp6XbP4xfUZWM5XOBrka
	lZXnCD8e8nF6Ryc+PNzWH7wpn6rhaf8BiitZewEGExD3Ha6TiExYbG72vnmY+/YpDFyFjnliMO9
	+6JxQs
X-Received: by 2002:a05:7300:c9e:b0:2ba:a623:c323 with SMTP id 5a478bee46e88-2bde1c938b4mr4203653eec.10.1772432397568;
        Sun, 01 Mar 2026 22:19:57 -0800 (PST)
Received: from z2 ([2601:647:4401:2cb0::4c64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdf0cd07e6sm5529594eec.21.2026.03.01.22.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 22:19:56 -0800 (PST)
From: Namhyung Kim <namhyung@gmail.com>
To: uftrace@googlegroups.com,
	linux-trace-devel@vger.kernel.org
Subject: [ANNOUNCE] uftrace v0.19 is released
Date: Sun,  1 Mar 2026 22:19:49 -0800
Message-ID: <20260302061950.7293-1-namhyung@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I'm excited to announce that uftrace v0.19 is just released!
This is a small release with bug fixes/updates and some new features.
You can get it from the below link:

https://github.com/namhyung/uftrace/releases/tag/v0.19

uftrace dump command that generates chrome trace output format supports
adding source file and line number information.

  $ uftrace dump --chrome --srcline

Also it now shows the timestamp as realtime with UTC offsets so that it
can correlate trace output with external events easily.

And it has a new script to show function execution time percentiles
(P90, P95, P99).

  $ uftrace script -S scripts/func-percentile.py  $FUNCNAME

As more useful scripts are added, we'll need to think about how to
deploy them.

And there are a couple of important bug fixes.

PLT functions generated by mold linker have different code patterns and
cause uftrace crash.  Now it's fixed and trace them correctly.

And it checks RISC-V 64 CPUs properly in the hashmap code.

And there are more bug fixes and improvements.  Thank you all for
making uftrace more useful, efficient and portable!

Namhyung
