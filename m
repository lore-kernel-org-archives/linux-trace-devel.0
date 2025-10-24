Received: from sonic302-22.consmr.mail.ne1.yahoo.com (sonic302-22.consmr.mail.ne1.yahoo.com [66.163.186.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14BF2E4247
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Oct 2025 20:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761336711; cv=none; b=VPOE3iFVIm33YCHJg8CgFohfyXMPtaKYBFG8r+5WOoqRAW0j+Rr0tWh+Mujwpzy+iWKAnkXA2JC/RNQ/SPIeSbLXXcv2av/cg1CTFlxM9AyMyrx0p1vpUaNpg8UwPiB1sj4WReQCNHJT7aVdsnVaN2Kd+vvPOGvZ4gr16h4NQ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761336711; c=relaxed/simple;
	bh=CW0hUF1C6dVVdMPOmpnV/+Cqcm01lHtYqp6hG3pt7is=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type:
	 References; b=rctmtQP4Ubz9LWimNgevHZdHi0s06lVThNwSNfNhCRN8/7R28SFRSiW0MbX7DBvTLWlLIV6iEr7LmAKMt+7BMJHRqmrYW7RNBsE0N95EJ7B7qthXHnmETb2D3F6Y4LceFvTAGl/6EZaXHqGjFlcFJq0ftnYDITxvQgLlWq6u6YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ULhKkyPW; arc=none smtp.client-ip=66.163.186.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ULhKkyPW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761336707; bh=2mI+eETA7qFZLRFx7ggIjFEXXRNSUmpw/JsAHitbbio=; h=Date:To:Cc:From:Subject:References:From:Subject:Reply-To; b=ULhKkyPWFq5TpE4p30RkrZ0tewXgingDsVWN1/JjKPQ00RbOtPRSA9IERCMG+ZapvclLz4ZTTFlgOwMFVWx36vwxrPuUgLS1ueXWbg/r6xiH3WQj2ij3FZwgHds6IX1gp7rjvent+Wezy8ROnToZrNPjKxhiZWudYGhV3F9huVm6YxBfP3/b70e+YKy1i/nznkeVbdpxh+gqQc0KNRyddmC4Tou9MTRMzAGOzv4z5jsfUGFhFb9SEV6AdKJMfNl24vJIcN0I3G513W39XjYryzvn4Nu6z/Gxp8JMoO8hKbUO8ojXaJQSHX6/LfIT2E+ryo8H3TF0TtLHtdlXLH2sDg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761336707; bh=Ub3KitMJjCkQ4s84PcXgE47AvVm1sbQIfTkd1VGZeSK=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=HTjZxKAvj2YoNVv8iWwRV6eCe5//BkNUYC+/d4v26bTgA8TgHI6Rbdo/LABKVIco//0Ko3dMHAbfl8XTo1uecuXOY2J1pKZcl48kSiUlA8EenHTuziT7rFBG5MfdNTu1yCIV9qPz+XWAdONN0BwFvrbnZ8MeCHCR08sUg4RljTQfblItv2ciJrYFCuEa22BWAyUmbHiYyqSj19o5iAWjJTA6TQ1JBlTtC1SCrzgHkp+1XYwqVOOa/pF9YU9A5wawVxCjA4+xZBemmNnK5EY4qShDDiITpO7DOSKV/0tDsGI8EjSk4LLYMrAjd2M+L6ME3B8MKgQodBi1UpTqr1dmpw==
X-YMail-OSG: ST2HqcEVM1nURL40rqJ3F28z3QsPqUKG5CQCeV84EaSQ3.DggRZLHqPYHEt6IF8
 fdJ.htfWhocPXlhZ7rEUmlcOqg9ukfXELQb.ROC2ZJYpeoQ.0IDqHgTpsoR.QpKUNr8dbJT6GpGp
 hiy7L9isBY.zewoPSaETiuGplweiX3C02nOFHd_OwNNZ2neOZjUd4DOD.zIorF0jQxRe_ujNgKv1
 l3t4fvbj2qlG9EnEaCcL5QXogWBgaW9NdNKRDotg7tAnlWhB_M_emH84wT7K1hm0aQ16cdhC7J4f
 xD4sMhV79a5vHNmTLtU4QvYIQl2pSZTGd63oIhDAE88ovpZipaRLvi43Rn9yuCrT1Wc2AKa89myW
 XwMqB7IYZ8R9HgEZ_V5jn2oKwqxhrIQO_dr7W3GxL5aCYovvi8e3YbZbN_nU3Jw1vvU2qoPm0roy
 .ZQ8oPPPybL1g5kFIwp1mvHk726Wb0j0JaFr6hPmvAMvdhZmVballuHG0bF3RdwoT3v7k.ZXGaxp
 xCumO1Z5GrqAtXpi443LvfgyALH1G7DOOOfMZbPsubYxY2FTrumaGl8uXysPNYT.kfONNTrYbGDG
 dM4HhFPg.769hKnk1QC1IWYvLFM1Go97BK7OtYRuPrBF3s0xR.Bdp0sXkYb5Pd4DtQuWh.WUR8sK
 rBmhyGF2_W.4TUjwzXwwarBPGNPVQIVN4srJB3poHTS_jGlcMxs2F.2HtXNcOxHTfRIdBu1IdScS
 Sl9k89Q8jvZXQX0oFHr1i8QxqItqRuXywpZ7DpB.GUnvve6s_l9HPqxQmfqzQgiiI.qyoiPIHQn8
 UNv71gxv2AI7MiIICW.mTuPFJLaH4aFNPNw_QuVD1mzLoKvnTUBpRaF7zzv0eOaAzsD2LSu9Awlo
 j6vhCM3tJFdTd1WaYRhrLFbLo25FDyXM0KQIJWJSC1qFVcSnCyM60ub3Si7FaKI4uY7ky0SyP7pd
 8sBFCUessVN9Zrr4CFYYY1M7fl1Mh2QRPIPo9GOvNshQtEHMa.d8BhQAuFH8aylkCD3OKQr9hi2k
 ugOK7gUlflrowjwlZPikKjcBH81VarAB3jc1PQ4hkXqlPLwrqCFvrwrnKpsUHViLSNh4WyNZYYfB
 Z_uPNxSKga9NV0lhhGR2JbtEjT_IX7yeZq2LZszA6a2ykeQBhlxVixDyd5XkZmdm433glH7VSPHf
 9DndfcgS0LUJplbSmuJUq1CaLndP4XI2Th.5787jM37b2hdJPeGIV.2cCcO.9AolX5awF9KRDPBb
 iXzNuYb6TZ9JkyeyUakwhZu.7CMJzMnXbM.Ku1mcnN_5U.IyQH5Ylwms_pmUrbV6SnLkzFZM1SFG
 eCtAAZljvotRjtfc5P57lOB4sUltkM5cje1LdkeOTH_mRXRelrdKdwO1tzgrA.QypfhaFYud67IE
 XFv6oPeb5Vc1EroMPY0iugBaJHxv645AxpzYEB5mgVdMM5GNuXGfw.Immp14Ep4lxzfSDHiS0tsA
 4bAdJ2JLmDWBJYTyEFVUush59xdpxA8c5dl1R3g_MXbp6Pwd7lGbhsqoq2aS2ebcj98EESlmBKKC
 8k4Xx71vaUpiY249vGGJFOxanvj8GtY2x.hB18VDe1qdD6Yy4NrVXEJkrH8FXYaPnyOAorj_CT5c
 SnR2z.4yzERBtQce2np._7y15RS1grAMZgjQ3idmdgnmb1FqBAeRDFGo_02V2GLQyipmypdXP7a1
 nx0zIyUGMj199kgGUYu00i_biwLOW81lifehktBPRQOH_ktBBtiBzqJs9WoT83EYyW3_VyPXeNFn
 aonYC_N33ei73DRyFIIjc62VA6mLhxVJszxC4PlYkrb3DSpjmh.NaOneogr9UA4dLI0xnAf7ldIb
 nE3BynDleJcgNbBsKRSEqCvV_NcjlbiyinwCCSlIbZJ25F1JGG_OYjn0WmUGvPNE5Zq.AJI1va_E
 qiCrv3.qyNLBGMe9Nnf7MjWhWP_5UJ.Kj5c.6bvI.MvtwsMyYoaowxvO91YDaaB1tsVJvZBUsVxN
 7ye3Q9EXix.DTaXSRaqp7uCytBWKI6uMPYKKiMzd2o6Yf78zuDkOfVE2OlxNaEiqCk0pPxG713vF
 z1F86P6YRbw5WYMSf9NWF8KiECFaKYiJ1sFr11ooqqaPXQyj9RP4ltV1w1Rvg6xv7Vy_m26709V4
 KWJmqZMHEq7Ug5EbzWKeHf5.iHYHNSRHaVsHMuNjbK.NMadS3RxGT_REeyTuCox.hNRgfQih03Y5
 YuxCvdJUyzYCJ9Dv4xNGAk7YizOSlarQX5FYIuLqm4nsRBvZ14hq86WKF3_29tcqCaDXAmgO_xO4
 -
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: 552ba627-9cff-469d-948b-13ebfa5a9ae3
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 24 Oct 2025 20:11:47 +0000
Received: by hermes--production-ir2-cdb597784-fmnpd (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 194f907e1bcf23af043227dc26fd9071;
          Fri, 24 Oct 2025 20:01:35 +0000 (UTC)
Message-ID: <ed24336c-4e14-48f5-ab0d-cd5f6f3f5c01@yahoo.com>
Date: Fri, 24 Oct 2025 22:01:33 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-trace-devel@vger.kernel.org
Cc: y.karadz@gmail.com
From: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
Subject: [PATCH] kernelshark: add .gitignore for generated/build files
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <ed24336c-4e14-48f5-ab0d-cd5f6f3f5c01.ref@yahoo.com>
X-Mailer: WebService/1.1.24652 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Not having a .gitignore will bloat git listings.
Created a .gitignore for all build artifacts.

Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
---
 .gitignore | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..38a45ac
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,16 @@
+.vscode/
+build/.cmake/
+build/.qt/
+build/CMakeCache.txt
+build/CMakeFiles/
+build/Makefile
+build/cmake_install.cmake
+build/compile_commands.json
+build/examples/
+build/include/
+build/src/
+bin/
+lib/
+kernelshark.desktop
+libkshark.pc
+org.freedesktop.kshark-record.policy
-- 
2.43.0
