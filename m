Received: from sonic302-22.consmr.mail.ne1.yahoo.com (sonic302-22.consmr.mail.ne1.yahoo.com [66.163.186.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49AD34E761
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 Oct 2025 19:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761678528; cv=none; b=A3kraSNmpw39XaXBLWsu/QLwyKrK//aS/63i2rGP7KvTVHOZf42IjGTkVvIRTagZ96Y5lDpUaueo70zhkBzAXIXMxOtpbfqwKQIRMt19wYMmNwBnRTQNRt4/55EOyOtGg1j8Ys/qhnww8RhM3DihMly+lR3WeNCcZAUdY0w+RHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761678528; c=relaxed/simple;
	bh=jVWQ+qjWuzVo2vFM3JVwZbLrpEn5cS981XS50aON/BU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type:
	 References; b=H3+XjlATwxhO0aYH+rU9T+apFy+WYYrtiPxvM/laHsNke/xmM4TvH6DE2zCerD/754jPjT9ctRIR2RmCs3V/e9sRf3l2AfRObQwIRWdzTjLRUE2TRmDeWIL/+ce78jP0DZtXrphcIF8tfMX7CP2XuDaCrBUK1RXUF3SxEE2cwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=bQ6mtNNH; arc=none smtp.client-ip=66.163.186.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="bQ6mtNNH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761678520; bh=r3orR8+5+HVL8OXAwyH/Vbl+kwdtfx0P9vq5CditNcY=; h=Date:To:Cc:From:Subject:References:From:Subject:Reply-To; b=bQ6mtNNHFRgzP0/cvv8TRirQurJK4vlzkWWxY5xi6aHGtvV8qAO0XtMocNll6LfGujvKPfIlPjcrXYoNUhYEsuZR57btA/05qyEjXIh+USSVoyDh0mxjH60TppRdN6mNBkmcN4QuGc+AfzOELeMiHLRaADqOLhVzeGdAc2CNNTOGze8rBxPwR0GHxtwU/zq9DGOm9BC9j7BUO1mVAy4yXzfyIsWxp1LCHTQkYUUnN+zIcaLqbS0Rs9sW24Pudu6NG433raW8J0yCTqeVHLmfuJLTwynNBncU+vmAfqqGF9Of+bPI3YxuexkyN4WeQfRhyAgeUl4UnNG6YgCCkfXhqA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761678520; bh=dViD0GVcgcDtnug68TNskKzjL0VIJvxvwfS514GKJD8=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=QBMrfomRvD9xb2/A2EMimfAMsQ8/HwnbhZN54g5V0UfThoXNVdSXcS7ouQCJovLo5f9AUkVnjFOtmH0IHETGp3pesqyhrOOa8ocQ91vjPWXn7PXkEtwtd79WUnumBGWjw0nR//UFYfg0xcy58LdLHMN9P4txwoO/JvUMZWzjW16EdH7If4CCiGhjQRON4NJFBrHCH23HmYnDiHxLmpQglci2em5Eq1GZh5mR1amC5v9/nnlJEd643FO51ATwT5KKjDBNqQ5xJ5Rjd4TD3EK5VY/tahw/BhLkXSaSe+eJ4bHYlz58OeEEfqvo8dPDjW8H8wd1TmkZzP7HGXi/J2aILA==
X-YMail-OSG: yD2gdzoVM1k5mLSjL5l3Ac471wO70xyhTOIidZu4F1lSyaVbZOvBbA87.9V2FMX
 DF1j7pg2zdRJBPBmYPWJL85Znd2Tov1nhYZiq3gXKzDJXQd1iPLS28tlEYaXOyffCMNA8omnnGyt
 mCBSRj.Oj5L5NTCsfrGSAGOoujwjQhJVnEWJi6NHzzELabwVsrXa4h5uIy9TNUDMpuruRejG5ysG
 X6vHu3d0vf9nxRfxFt81ci8vvAfUJ2bKMzseMMmDWaflNpQ1wJ0hnlLqD0nrIoQeWoM4PMt3dpTo
 Li8FO7beBxnBfK_Tyc5orM5fmHWNCV7VABrcsuaeEBITkzKHkt2tGCerTHTDBVY_UjmDMCZd0xoo
 QH2SrBxMEpEc1zgqEdTY62XQZnpMEdIQb8L8poIHiKUt4rgZ97zzLGR5lqsa6LZOzZzoBwwqpxk6
 ouq8gwC3YoEqqqrQwG3ZHpSTBzANWcYwpNisWTCLgnzZfjQUDvnzaKPiXZMb3ODEUuj2mc1vO_Jw
 cZULp5JBnIZ634_sq__Bef.cQRgkC1Du6oKaD5_wJNCbq1M2NVMRwPJXAEM1_Yrlpa2tZz_rQZJw
 Uh5TM8zxXtI.8_fj3Ht6gJpIX4LXy16nAItwJfhYO_inH6dqIi_DSLyWvfyynlHuqPTEIVoq1Lan
 giWKX0qKcssDa1B9LVkmNQFppjzzk.4_pRdQoQjdcjOMc0AHbHr0ly2hmgq44Xk5DgnqbJwtCVKh
 5JFAJHNP8GOge.YFT4X0V8LJgDERdbR2A2mYL6uBAWxhH.fOKhyRdBqvCBsCz4AEa1pSHQt0pbVD
 yibTalVpa2gRUUVec1AsUE8L19rBIbxZUTIg5RjsD0eTukOGBeJ9ocAbAcgp3XgEnJMjx3Aue3jA
 YW_wJ1AnzenL5dKsESGRTRSuXaYzjYMRaWrxISMlop.avzyvB7XZmEFbczI0_Ylwy3upHT3UsINZ
 sil15oaFV7HqwgeAvGVyoQtegfPN0ORAZ1UlbaBSASRs7HSjP1B4f0AB3Y1w_nbTd4bmgn74Vlcr
 L8iDVZ2uh.KEgBknfcpf2mxdBuK8RZBlfQvXIAgRV3ZV1sks72UMWFLj_Bg6fM6zHR82rcOalz_w
 zgnwqA4b3AC2DvdUHctlAunrrthwDL_4X8m.0zfB1UfJmianHynDH_6zLYBWtooqN6Vw01ff_9xd
 5HAmfHiLj9_ETWbfWHfWa5qdgpa0DkkSBOuxxrAZ7n05YG3cmt3zLeN777TifeUTgPRi9vQMRZ4F
 vLWCTPxLaGhHGgLfSgIK4QiWeZsFpFB7jKxQ_TiUadzeNDXHxzheF.cC.hhASKIfPKsNLkLAxfJv
 _pq_1CGj9sNVmQI5sF2yXQBj8Axlw_D50Tup_OuZCswNeD5MAKT2AQGiMc6w1vjB3pEO2cealDk9
 QTwk6kCUcgy7.cABh4kou_BtnUQkHpu9isKXMAHf_itPOjHeblz3t3SLoOx70PLLMJtFrO4.X1vK
 iBbvhtvYzyfxIWR666vJBDRkE_P5koA0.GEzekpPXeR8KX7_yVp_50tx0RDVvPRktX0fmoZxbBkc
 bqfpJNK3jzwQwi9c..d7RzmUwqeV3qnh1p5aqcFI63m9UzlRjZcIJ.V.pTPv_a7MNfFM8IKYPcUj
 leypQmtgK3GiK5l_PJr487qyrRPTEJgCbifyNq79KQNJDRxvC32ltHfk0rMR5tJx1nfIdq_7jfMP
 VRCUdvLhs3kBlfLJ9wAQ4jZjHqB6PgeDWdoo5dRHYuQNnAPV9ZVTlpXOrQ01ejpR33X6YAtEOa2m
 hWXLYcbL_Qieqi.AG3Ylb52BvFGtrDpcIL4XmBwpgJjrnk.piuaKTMJdnpCeCphpzlRylHQfnzxT
 visRhmNTiHTk4M9HxExECwOFSkSzEocVwHqWcprQdJk72bwoil9QnKVt22mp6kUO43ixniybfsor
 tMha9xje0SGYmFNBTEoPQXjAtTuGH5YXogr_3vJj6YxO1MYjBgoMdXXQjTfuwLmehe5v3bJDEpjw
 GYr1LGkKDnGCEi0kF9uJmUvFhoVuSuv4IjAQSDNuYGzWn1e1CZ7qPVdPVODwlqk8ZzeHm.KR7gMN
 Qp8aeQIIS49kpSAspIQ6JeRKUqjUCXXBOnk.tJzjwiXNzt0aFn.uZN1jzVvr_Fj60bAVbr34Z7SR
 OA_kmpuyqxfTGUjfc1EjDeOOlvDO3d8pGyqIs.keJRyMrrcsB1lH.QDY9Cp9VHiyBsnsIAz7HdVA
 EKurjPjB4mNLFyitbPMt3cn3hrKuFs.rM.f.8R7H_Q4sa9n6CL2H4OeZ3ejiIMsVMKsA-
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: a2a830a6-acf0-4554-8121-2667e8334953
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Oct 2025 19:08:40 +0000
Received: by hermes--production-ir2-8c47c9895-49nsk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 3fc0d29e03b68de823f076e3fbfe4fdd;
          Tue, 28 Oct 2025 19:08:34 +0000 (UTC)
Message-ID: <7f44503b-2ae8-4ac1-8635-a5dd4d0b286f@yahoo.com>
Date: Tue, 28 Oct 2025 20:08:32 +0100
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
Subject: [PATCH v2] kernelshark: add .gitignore for generated/build files
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <7f44503b-2ae8-4ac1-8635-a5dd4d0b286f.ref@yahoo.com>
X-Mailer: WebService/1.1.24652 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Not having a .gitignore will bloat git listings.
Created a .gitignore for all build artifacts.

Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
---
 .gitignore | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..cbeb499
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,24 @@
+.vscode/
+build/.cmake/
+build/.qt/
+build/CMakeCache.txt
+build/CMakeFiles/
+build/CMakeDoxyfile.in
+build/CMakeDoxygenDefaults.cmake
+build/CTestTestfile.cmake
+build/Makefile
+build/cmake_install.cmake
+build/compile_commands.json
+build/examples/
+build/include/
+build/src/
+build/Testing/
+build/tests/
+bin/
+lib/
+tests/kshark-gui-tests
+tests/kshark-tests
+tests/*.so
+kernelshark.desktop
+libkshark.pc
+org.freedesktop.kshark-record.policy
-- 
2.43.0
