Received: from sonic310-24.consmr.mail.ne1.yahoo.com (sonic310-24.consmr.mail.ne1.yahoo.com [66.163.186.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD42ECD10
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Oct 2025 20:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761337123; cv=none; b=feKWH9O2OxWBN9RYSv3AJjFiDB8J3iID7A0b6lCI6KCiBhrpECYl2PPh/esW86mOKrteV8NW+GRgwhkFJ6T+JkNZ6WCcZqZvigBgloCnWQnCE8O6nLmnNq/CH+hFgA7jCJUr+YRmXNBAIP5nMLcaOMY5l3juuR3EDv288XOZmBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761337123; c=relaxed/simple;
	bh=PH8eQ6MQlfWebkxZiAnJ4Bht6xk8f8Q2LeWM6hVu4q4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type:
	 References; b=Tlnfcp1R/+5BifQGMnH4Cp04fJqQRN9du5xKLLHDi6aJxdY3P9NN8nN5i12jCHmarwyM079b0OfAbOYBIsrfjtwST2+tOGjksBJyMNXwKc3gXp4JzG5cyqQcHqWw1ThhJ2Lhik5MTjNQvVkG7CrfNhvbym7G0lPZxEtTLKdCVa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=oNeKn188; arc=none smtp.client-ip=66.163.186.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="oNeKn188"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761337114; bh=2OUqLwYEP2l3urb2nJ3vgO//0em/uFWc3i2ydg+LqHE=; h=Date:From:Subject:To:Cc:References:From:Subject:Reply-To; b=oNeKn1888fLH92gnmSGD28v+C/XL9u6ZLW3t5sJwdsegefNxCpuo322/wOdSR15jn/gPCJM8ksndK7ACpVhp+2oX69/Gpt2grfKEcFX8t02SjaYDAA7ifTpmM/WCPcS5sKJZoJwHiu3EsjPx9ZLViB7HuHFVZQhwnk8ITHqrr6lYZSwH4b+h3GKoI1kIlsQIFYSU0bAeqFVRcN55aigiwHgWHutCpPMywBlrZuBqC0Tpb4Enytb29eXfMl4vYiN7J8l0oM5NXu9yDBh3sQA7/XgZ3803wCpW1uzUL76JT6sg7ieViLU9WgwQ2HFrc68IdxrXOFT68TTANOvil+rwSw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761337114; bh=1NvEreTWwikCWBgQ6olXoBFB1ltZ/WQyfu1be0sbMTz=; h=X-Sonic-MF:Date:From:Subject:To:From:Subject; b=qyQ2YKGkuF0Li1uTgBt+NP7wxdSoyZuAqph9XvWeJfXM+0t7TIGV5sJk/ufBOGwfspQaoxIxNoSBE/DfH7tuQ9yisWoyh6J0a+D4ZYtD+tG7bqze3WrEY6X30W5tMuzhzDHtdQBJTYyWUH6BPJYgb6+4T00jAWSvDrllSu3KszZjTgf/JJp8PrBi/7z+rG9qDMAnSQqjh5sQ0smoFQeknCyRgRniWTrFP15WM+vHoB6xVp1GP+pQHGFSmA0gfjnz7KYCeNw01bAavh2vzkuhWjduAM22MtoQndiqivxjp7/zDWbAC3dUTih48IwzrKROVBNeU9U05toqMVTiurNWbQ==
X-YMail-OSG: WwMKGO8VM1nmg0fmnJnY_LN62akeBfc66ciBDouDtECqTIxO7PbKgm18_0Us6Wj
 ZXl_4CYwytdl1CaJjSy_RV4D4v.oy54PWmRzutAwjIZkCKgyG4m5t7zWP1jKtYMUttu_J5lcRsTF
 jCCCfAqDxfjMMuC8udVTt090QZzrVR.pBQH5eS2Zb7NW.JkgMSSChmh7dGrUTpE2Y9oX96KpsUjs
 NsnAujzA7v2CNEdvEiWAbeymwXaAZnME1CMDrEDQF8AGsL5dPZhirUuOU0WB0anp0HRjLpkAlM_L
 El7L.lUz37tryYlJKmjfjoh6MQAU3FrnGoxTKMttgNyuPqa0pHVnovvTkRUEIDhx4W_5owZLKBRG
 P0o_Ztj5ipmkUJDnQzpxt84.Z9NfjZuaaJ9prwqE.9yWFZAU6yR_jZuyYbjKXnLOP0eFsb2iOMkF
 zhvQZAhj8TM50TA6HiKGCyfQY2LcTHKGBHW2PoTH7OD2afWDPtGkRUdoLQYDTsHaAckD0BNScKKX
 aazuGicQi_R2cNC4mdHsXgtU9iM4hphF.1ZYT_wUnfib8Ha_nIU.jFDYtSio5SNZ5.qfdQ7ybmJi
 MLDSAgcYhMDNANkzA5DQRVlIhZPsiyfHDOKLrYxllrh.79gEyUdHIfIl6QVDMGuytV_sbHM5LqXm
 VEbrStEiXbtHbNUgGn2LAQ5V.YmJo_zD65xGLbkg5pA8EVGoh7LyqArNcu6geGtfGmtMG7gmDW2V
 cVKM8uG3UKRAgBAvP2auT4FC.FrFtUDvav1.zmcYTsMIg52YPFy2QAO8Lya0SmHcgNStRYtLW27B
 akwsDvqZRu3rRRUDKAmi55eNb1C4zyWhikMpGOM7iVILXjz0O_Ujq4fou.qHI6TE0W71VlmxwnIP
 lZ9g060qJ884XRVCzQ87LPTWKZm193bMyQCNeXxcElzB9.IQETBb29IrBIXIJ2s9oYWShErdrICa
 EA76Cdo6vqsF3revHzlAuHR9cD6O9Es7EdJQ4JSKfJcUT6Nmd5WHuK1iu.chUWSP8246sG6noeV9
 QOwLwJHVIzU76eeUoD72WrNLOXfh3ZaOhhyi34vJPr43k4Bhu9SvYEUN16XCOCZkwkavaMhQx0AJ
 sP4Jz9eD5QG98VAJvLaJaaZnMuQLqonal88VlJwhZxYfBPNkwBNM9XQJWjEqEVsw6GEpSmL9Etqr
 BiiLeTTaRVGtARjXNouk_X9eeT.NuJaWhDgDuxncs_y2wmArQ5YghF8lj1eOudYqufhSGbnm0Hzb
 vu4ZtUKNeNyAE7nYngRe5PHhQvEpoGnGE3Y4G5AWMt1ZH4Qja.t8PW7VOKfHtWKNnlnygefYUM7f
 tb1TO9xuguLrVK946TJbVX5OtI8YfDrKauM8sCqu13pzvcNc0anzAURCAd6Cu0mCyzHrUn0M01HZ
 r4ZDUb_gZV2TjXrThhTx7UMSxQiMY4yGKHNgsLi.Ve.o2i83r6Di9N9NdfRveXkNX3CqjbLktl1w
 zQBM5zigAVC5fh_KEiiRIz8mpMdRBa6OCSNPIf48gVw2yQgvHXnqw8xk_zJpXINiY.XRwmMn6C1g
 AYCmkYq01Suh1IOmx3VgTXQH_wyPpW8LDBk2VsZbiHF94g0lGhffVYd6G3pw193a.t21Ws3l1lQR
 ckyV_a66HqSK65VCTGMOPfkTKGp61rStwPSrHJGM2AXzwXkVvO3MlHehFSs_.UeQQPXvNTsX_PG4
 JB956bAQJL2ZMGLpS4umx74XGqaTXyey74CPOKILhC652G7Pimgr2l_SiZAvGpj9cZuGCqao6yW_
 Cwxo9UoJBNK0FmOHu2pbkn1z0W9PbyKJ4dMTh0KWHKksSX2o6nguBfApUvGeeHcway_Hfnezfye7
 ttWOUbY5ZR07slHXtNzsSlQGWOQ4leZw_w0k_APFc.RJqdEfRKiz0L.dzU7RIRIknxfcprWPdBL0
 CSR5kvMB10608Pvq9sPl0nzXW9lm5mtGwjElp7UWqD8yECxtKsEwYjvV.4blf7Csgq764nYeq92o
 AC0qNffGowDSmxRfKoKR9Q8bKwMm3KQDbmNf0ol4TTN.1KEAPRIAjnYwXg7D8MDly66t3fhaSWai
 IHKctcZFgWxiPXj3cnPBvdS0e2ZLbN7eM0wXVaqjIiLeLnNsqan4yKOzMDX1tzj70C.6T2XO2yBN
 SZ8n_rP_g7nu_7IS2EBo3xNlXfMGR3u.r9z7hD4uK6foGfhvvLql7AxIjxDTAjlPNR7Cpbn3DeGj
 z6B4.SCuv4Gh2mNZTqEUhDEtjEw3fFVvBTAaqmewPWWNasJNRZu2G4MbJX45.YMAaLZpB
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: 921a9463-a864-4087-ae47-5a6eb28faa27
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Fri, 24 Oct 2025 20:18:34 +0000
Received: by hermes--production-ir2-cdb597784-z6mxk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID df699c6384cfc4ba1972a7fa690cac78;
          Fri, 24 Oct 2025 19:58:15 +0000 (UTC)
Message-ID: <a5350178-93c4-4aad-a503-a622704fe764@yahoo.com>
Date: Fri, 24 Oct 2025 21:58:13 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
Subject: [PATCH] kernelshark: generate header file in the build directory
To: linux-trace-devel@vger.kernel.org
Cc: y.karadz@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <a5350178-93c4-4aad-a503-a622704fe764.ref@yahoo.com>
X-Mailer: WebService/1.1.24652 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Mixing versioned and generated files will bloat git listings.
Put KsCmakeDef.hpp together with the rest of the generated files.

Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
---
 CMakeLists.txt       | 4 ++--
 build/cmake_clean.sh | 2 +-
 src/CMakeLists.txt   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 54ff97c..84215dd 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -129,7 +129,7 @@ else (CMAKE_BUILD_TYPE MATCHES Package)
 endif (CMAKE_BUILD_TYPE MATCHES Package)
 
 include_directories(${KS_DIR}/src/
-                    ${KS_DIR}/build/src/)
+                    ${KS_DIR}/build/include/)
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
@@ -163,7 +163,7 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
 endif ()
 
 configure_file(${KS_DIR}/build/deff.h.cmake
-               ${KS_DIR}/src/KsCmakeDef.hpp)
+               ${KS_DIR}/build/include/KsCmakeDef.hpp)
 
 configure_file(${KS_DIR}/build/ks.desktop.cmake
                ${KS_DIR}/${KS_APP_NAME}.desktop)
diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
index 67afd6c..2c05d3e 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -6,6 +6,7 @@ rm -f CTestTestfile.cmake
 rm -f DartConfiguration.tcl
 rm -rf CMakeFiles/
 rm -rf src/
+rm -rf include/
 rm -rf examples/
 rm -rf tests/
 rm -rf Testing/
@@ -14,7 +15,6 @@ rm -f ../lib/*
 rm ../kernelshark.desktop
 rm ../libkshark.pc
 rm ../org.freedesktop.kshark-record.policy
-rm -f ../src/KsCmakeDef.hpp
 rm -f CMakeDoxyfile.in
 rm -f CMakeDoxygenDefaults.cmake
 rm -rf .qt/
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 0643365..da31f8d 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -71,7 +71,7 @@ if (OPENGL_FOUND)
                   "${KS_DIR}/src/libkshark-plot.h"
                   "${KS_DIR}/src/KsPlotTools.hpp"
                   "${KS_DIR}/src/KsPlugins.hpp"
-                  "${KS_DIR}/src/KsCmakeDef.hpp"
+                  "${KS_DIR}/build/include/KsCmakeDef.hpp"
             DESTINATION ${KS_INCLUDS_DESTINATION}
                 COMPONENT libkshark-devel)
 
-- 
2.43.0
