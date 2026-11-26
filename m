Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704614;
	b=ebgbwM0FVJFeVMmFnBWQTh1tmM+paXgiOEDovlg7zvZrBcvUGcJwYoNpJStLagEx5jhL
	 QU14rfTSwRpxtcWHvarON4mLiCqbD2cc8132Rcinfr8a6uEFF+5n4l2plwHfZo7PrWsIB
	 Ftf1quPEewKkRXkBrdYmuLClS+9CLCDESlhaLLZ6Dr7pSpISEV8pB7I52yB5QTuQZIT2K
	 6b2xWMIbhGvUIrAj2nN6vdVLg4JdLp8AnlwONmVMGoduDef2PV0jdsk9jFu2adEEspkTH
	 3QOz85bazrVaDZK3z+aj8E77wLjrN3/vOlGWM69KxlW8ZeNwMRKThaRwmooCE5w/nhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704614;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=VrkM5bWWPAMwrLxs5ncS3eY7WgZ/eJ59AGt4sb7pzQY=;
	b=nAG3Nb9hU8NJaB7cS9LcWuoaBzrb/H0tF2yNrR+pZJZwZy/3E6kEyim5kI2joC2I/Nyn
	 uNy677IyY9hxNk6FeOf/PVbpX72MjLyk1gH8V7K2iKYgHVzHubAjRCgxzWMvtMGp1DhZU
	 +vit7Qfad7fvohrpWtp3VSstkpc2ViS1Y8aZHdpFRVStEYezO92WN9FwTQFDh2eF2Ri4b
	 IYTpsJM2WKlTzHY7DhWDND8tpVHBKkLRAshd4adEFmU6LOIO7UmgRzGMsduqq9J0EAKHk
	 LzQbgnTfuyXoMF68wYoo1hMb1w/ZnR8cpH62ZjXbamwofKSE6bcb0Df661ZMGshkyxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=afsIRnCz;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B23606A31E
	for <linux-trace-devel@vger.kernel.org>; Thu, 26 Nov 2026 14:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53B23606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=afsIRnCz
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb66245c51so4175915e9.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 26 Nov 2026 06:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795704613; x=1796309413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VrkM5bWWPAMwrLxs5ncS3eY7WgZ/eJ59AGt4sb7pzQY=;
        b=afsIRnCzCrH8EQIWI7ADprUYAnyjPucgHWeeH5TuNHBQqjGDKIv39/xV1IB4RJVQBS
         htQyYqZwG6yZ8jGmRj5Brx9DhB1ylOJ0do8Pf6uvBL2XNZPNrEwBzWaO+0qZtsqExEpi
         xAgKb8I9I3ZNyqrJOADySeuYNqlWCh5aS3ZtBxJS40WAV/vgkULiWzwC/6Ls5OEhhq8Z
         Xk6tLMq2CKhH8isGQ4FYa1Znxe/bZqPuE8gtercXkxNpSkmx93a0uozZxCoHbZTsMFB6
         Eml0G0T2hFA+Buhx6jk1g+iu/HKu+CYWei5/lOjBLZAybcSKbEena226oDwqsf0K7KQR
         nrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795704613; x=1796309413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VrkM5bWWPAMwrLxs5ncS3eY7WgZ/eJ59AGt4sb7pzQY=;
        b=J43KhKbAZQ+QfGck0DsPO1mWs4sIWddfeCOvepxb1CekZdCi/EX8X73wkyBpG1CR47
         qnhjqRSMInlnrhpMGgWFoKXfp8loUhp8loI+8Pag5PMdaF9Q49eaKaZaL0SyFxDclZiT
         GGEtuCkE8k8lR8wOzPWq2CBD98PT6E7OTr99eovKrvGkUYJx8PNSvnEf7T8BogYjpG46
         fWVkPrhOHsSUixCt9Y6AvMktlLwWmhMn7Gmdn+nyqDc4+Bx3jUvpIv23jIJTIHS/Nd6+
         sxc0jfUlljHTxDfCq5MyliPTgmAitVME41Fc+r60UkdCctaAszJS8EvCnnX0fu7K3M2c
         esFg==
X-Gm-Message-State: APuU4Z+eMyigYcnJmsCgmPXf9ieATiQb2HDDsc2/PHZB49GfesU1/6kY
	Vc2Ye+FXZ24/7EmU/QY5NrmTPk1zwUsZde7JlacqL6bBwe7s7A4HhFpY
X-Gm-Gg: AZFdTZcF4qQxXSGUB+/ZhgaXLa57U4TS9N0aB5gYqIrtXSbjuMkteU0DLA0UAi9k6DR
	7YhFJ4scpbhON+SUqLVWngrrXtFWXxkzhpLnrEMlHqBtr6Luu8cuS8JnQ+t/T7TWcjNWPZDfaaf
	+PAyepC/YAkpDyiAiKbdoZB9afBLKTfuivqLxvHzxHEtl+sIxw2VzIbODU2oPkDTb/UM1f2NMn9
	Ol/Dcd0uf+UKRTVMf69+MbHiyKWrxQUF8hpkhhkYVr5Ej/3jtb9awbUCLUK435KUG/SM6d0yt0H
	EMQ1JFYgrqeM1lvaVuPqEol2IdcsPJKxolKobKyO77hnuxCs7/NSeEvzHov6JSgmyyLlkLmie+v
	x9VRN2CymK4VOlpyf3uwTtDoSkFKZvdXjw6IdDWE291rHiMDDIUni8Q7b+kcd2ZST86a3yrBLlb
	7CagRkesQavethtLbpG1V4RVaXxlDutLThn9LCCzlLgQmF0uv9UNUdb0nchMxa/QQ2yc4eYWInT
	BeofkClCCjbatuCRy0jTfdsyF1/VQi5xnHZBNDrK9/v2ULrvnAxt+FVKBdfByU9++EpuoNqxIF+
	oFIufdM4PCOH2Ogy9P1GfwJZaFrN7JxrBSQGMOt6Cd8=
X-Received: by 2002:a05:600c:21ca:b0:4bb:68ed:a356 with SMTP id 5b1f17b1804b1-4bb887ec919mr294443025e9.1.1795704612439;
        Thu, 26 Nov 2026 06:50:12 -0800 (PST)
Received: from debian.home.arpa ([88.97.179.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm598631655e9.5.2026.11.26.06.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 06:50:11 -0800 (PST)
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] libtraceevent: Fix BTF header size validation
Date: Thu, 26 Nov 2026 14:49:53 +0000
Message-Id: <20261126144953.918779-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The btf_init() function was rejecting valid BTF data from kernels
prior to v7.1 because it compared the header's hdr_len field against
sizeof(*btf->hdr) instead of the minimum valid BTF header size.

The BTF header format originally consisted of 24 bytes. Starting with
kernel v7.1, two new fields were added to support the layout section:

    __u32   layout_off;
    __u32   layout_len;

This extended the header to 32 bytes.  As a result,
sizeof(struct btf_header) is now 32 bytes.

However, kernels prior to v7.1 still emit BTF data with hdr_len = 24,
since they do not include the layout section. The validation in
btf_init():

    if (btf->hdr->hdr_len < sizeof(*btf->hdr))

therefore fails with "Header (24) smaller than expected header 32"
and rejects perfectly valid BTF data from these older kernels.

Fix this by validating hdr_len against the minimum valid BTF header
size (24 bytes) instead of sizeof(*btf->hdr). This allows libtraceevent
to correctly parse BTF data from both pre-v7.1 kernels (hdr_len=24)
and v7.1+ kernels (hdr_len=32), while still rejecting truly malformed
headers.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 src/trace-btf.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/trace-btf.c b/src/trace-btf.c
index 2d66e01..43b08d5 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -257,9 +257,14 @@ static struct tep_btf *btf_init(void *raw_data, size_t data_size)
 		goto fail;
 	}
 
-	if (btf->hdr->hdr_len < sizeof(*btf->hdr)) {
-		tep_warning("Header (%d) smaller than expected header %zd",
-			    btf->hdr->hdr_len, sizeof(*btf->hdr));
+	/*
+	 * The minimum valid BTF header is 24 bytes. Kernels prior to v7.1
+	 * emit hdr_len=24, while v7.1+ kernels added layout_off/layout_len
+	 * fields making it 32 bytes. Accept any header >= 24 bytes.
+	 */
+	if (btf->hdr->hdr_len < 24) {
+		tep_warning("Header (%d) smaller than minimum expected 24 bytes",
+			    btf->hdr->hdr_len);
 		goto fail;
 	}
 
-- 
2.39.5

