Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7602C235B
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Dec 2025 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766500956; cv=none; b=Xso8bGBRvmPR9nSSFStU75XxLZugbhXC29IAsLz2O5JbYXckWW/vXThQ3YXmJGEGuJawFQg/IApT58eJ3k5v0d+kfMVbrCvtQp3b6c/E5FNYeS7KkQjkET6r2G0wTvrQtkM/H3y8I1I9Gaka500qewF65sV1hvM6Dr0XNrmeH0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766500956; c=relaxed/simple;
	bh=0IQ6nFZW00ENxe832PfPo841YN3nurGfQ0WsabXJ3L4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GlWjdzyW3TuItbrWBnabiXDYIH7RmfypAHhE4TsoRnsdP1Ocwv2gEjtb/AbXx8U4j2A0pHS2KCcQMBjB05xJNhbDtJn6OGB9PL6GCIqW/rAdp+HzAdcPj0ymcZPkQGuFEnFkwt0Y1kz/3BxG+eu99d4/OF7qz21B61gQwM5H+oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/+nhZ+J; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/+nhZ+J"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2a07fac8aa1so54863935ad.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Dec 2025 06:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766500954; x=1767105754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0IQ6nFZW00ENxe832PfPo841YN3nurGfQ0WsabXJ3L4=;
        b=H/+nhZ+JghXA6ty425k/EziiBG6NVs9D4xTmqtzXZ/QqzmE2V/S3q/4EvfPVicrb6n
         OZnlp8uITxFfkjUFtpu8qsryRmAzPK0rZ6M/BLWDkQCuPuJLKQKa78EiTl826D1mIdDa
         penAPlctoZm2Xuq/AZ0eSzpZ1lPksDqmHwqU4UDuo7/eWqNUq449IBKQWZv/nqly/s0h
         uyhFIaUGDOGvxLvAa0Ic282AnzZcCSP0btjFJqf+AddnfqCFk/+Sqqyrlv/2P39N7ndM
         ZuTitwYpHUHUQxMn5W/cAcaH0HEH42hrbV925aeX+vmLHINvRl8NnqFUmMajoue/185f
         X+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766500954; x=1767105754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IQ6nFZW00ENxe832PfPo841YN3nurGfQ0WsabXJ3L4=;
        b=fcKtfcSGd3r1UsWfzb5ilYGxPU2hDfMO6CR0jpDskl8aPedd9jtdMeAZQoQDDbHrhd
         x60hk1Rex8xGdvngfacI01cMo7JYLy2RwimjXOrp5+KTFZdi5vZgb/zXLSu7YRChEt4s
         Hu1af8GOAHuB7p89BgKH/NQIzW1WUECQEjcxDooTd+F18f1viK4IioD4mCm7ppTkfSzJ
         hRkT3LKlRbw52Sz6ii7nN88b5ajp4kmNjgyQGIyK5+0C7hGwg1i9duqsAsvj85Iz5rK5
         d1g1gPOFngAFuh56+RFYA18Wg3W32T2ayvXKtyCTU8DuLX6tEns/UIM0GcfXy1Z1PYV4
         NiGg==
X-Gm-Message-State: AOJu0YweKaEyhQ3qzT4AcQPAmWCxuwTA7jkGkJVltAtv/+uhNYnUvYTC
	IqLFTB2anzvKKlu/9UJH7NvCHPz1YemtUoWOwH2MEaox7pJBHK6UUcRnlAA5CEQ6gdI=
X-Gm-Gg: AY/fxX7hsZO3w6IWusDKwhbVWX/4CoiyeY8wSEznsYLhVH68OGQwF8Bmj5oOGOrWpPO
	V5dvwKweYNA7ozj4YQr0YwVpYWx38Q13Lnl86k+Ic76EN5Kj0Mybwy+YhRdCk35pKoOEMs5xRde
	ErVLJOAHbRIDpmmReT/G4ABgQPt3I2Ub39APYiUuqxxYKlIylaespy2b1D5Qau3in6MoNyMoOwQ
	XJoAe7mPabOUBVoiPGSilMQ61HHAeRKzRR+WzjOeYcEVi+Yi/cHvJXB6pG2DlveNL0iIUU53clJ
	UmSurxPhtSAHvp2qjzFXMSn0zDO6RXoKD1WG2Tnx8AhiLTLGDpgmG2RCynFWqNUiPaNmjjSGsr8
	sW+hThccegVCznwaP2z7rCC9ZGyyhXumdDDz6iWd1Vv0Bc1BLdq42dAz1UlFD8rxhts9mjzEswe
	hpjXBFDaJeBEXRfkmcuBKxwkjAAGjkKkJ8xcp4UiZNUhlMDw==
X-Google-Smtp-Source: AGHT+IEzmngfXv94XILrYvCZR4CaFsYV9WxWduYRZbpt7U09q8NtE7xMzT30ZNOgASdKmtmzNJkWSw==
X-Received: by 2002:a17:902:c403:b0:299:e031:173 with SMTP id d9443c01a7336-2a2f273241fmr143819795ad.35.1766500954289;
        Tue, 23 Dec 2025 06:42:34 -0800 (PST)
Received: from DESKTOP-J2JE76D.localdomain ([183.193.49.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e7710a5f8sm6411784a91.6.2025.12.23.06.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 06:42:33 -0800 (PST)
From: Wenjun Huo <huowenjun.dev@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Wenjun Huo <huowenjun.dev@gmail.com>
Subject: trace-cmd: question about explicit host endianness setting
Date: Tue, 23 Dec 2025 22:42:21 +0800
Message-ID: <20251223144221.1624-1-huowenjun.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dear Tracers,

While reading the trace-cmd code, I noticed a detail in
tracecmd_alloc_fd() regarding endianness handling and wanted to
double-check my understanding.

In tracecmd_alloc_fd(), after tep_alloc() and plugin loading,
trace-cmd explicitly sets both file and local endianness:

tep_set_file_bigendian(handle->pevent, buf[0]);
tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());

I understand that setting the file endianness here is required,
since it is read from the trace file header.

For the local/host endianness, tep_alloc() already initializes
host_bigendian via tep_is_bigendian(), and in the common case
tracecmd_host_bigendian() resolves to the same value. So in practice
this explicit call usually does not change the value.

My understanding is that this is intentional, and that the call to
tep_set_local_bigendian() serves as an explicit binding step, making
it clear that trace-cmd confirms the local execution endianness
after parsing the trace header and loading plugins, rather than
relying on tep_alloc() defaults.

Could you please confirm if this interpretation is correct, and
whether this explicit setting is mainly for clarity / defensive API
usage rather than functional necessity?

If maintainers think there is a better way to clarify or improve
this behavior (for example via comments, documentation, or code
adjustments), I would be very happy to help by preparing and sending
a patch based on your guidance.

Thanks for your time.

Best regards,
Wenjun Huo

