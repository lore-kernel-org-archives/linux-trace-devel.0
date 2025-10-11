Received: from sonic314-20.consmr.mail.ne1.yahoo.com (sonic314-20.consmr.mail.ne1.yahoo.com [66.163.189.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD783D76
	for <linux-trace-devel@vger.kernel.org>; Sat, 11 Oct 2025 12:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760185554; cv=none; b=f0s2W4cVPEzS4kH+GEt5LD2eOGjWNXz3apkOmQl85FoS7H8BEk515+ulAGaGuxNPeif00866QA84m2gd+QYMv6ECIwa2V7g7CWQE5qIwkrUFj9ycgNaXQJv7sVcm+CJBCep0prUuYRTwsbMv/MXQgQ0JmzvhThU0KVvWzq6CVyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760185554; c=relaxed/simple;
	bh=vUWWdSmvcEJM6d06t5tFJKBGmKlHHLPUGAjbweAAZc8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type:
	 References; b=HU55d1BG/L04Ls4s2URMFGVhAfZAu5VGJf6YhBUzEu79vtXuRJdy53PduKjXbu64pMTywsRSCmjs1xuWgtK+kIaAHAViTwt15LNqBa5ypKq/c4hyjtBhPc9sdqnTv1xX8J48LurYEyPd7N9tIPZz2ThakU4xTd2hNNNm9lxuNeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=okOO5hda; arc=none smtp.client-ip=66.163.189.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="okOO5hda"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1760185547; bh=71dDQmdDjv68RuhrC+RxXBbDehMycf7BE0iuXhrD50E=; h=Date:To:Cc:From:Subject:References:From:Subject:Reply-To; b=okOO5hdaWTnUlx2v+SXwZVEQGm7AqzI0n4JgXb1mvaQ/12J+lRskMhE38utmi1C3SgAlzjN4+Qa7S59+5o2wepakDZgh8EbQFiPkDT10FazyxWhIUul9HOi5M+SePW64YZz7NUKW1SvIBL8aceHTm60eim9D16BNaixEG3P5L45jNUDBNmPv4cSGjr5Hsm1+4D0C1te9SeUA4ywXgRKHM3YhuCTfeStL+LNZjyGUHaii7JBsXebxXtDFDE31Aq1NYQ1lDpm7tVj7KNPYhmN47vzUwyT5QLgDYeBADFek4zUB5XkhSh8KLpfq6Q+UPe7gB0qzB91E2Of3pFUey9GdUg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1760185547; bh=2KBTfa5F4F6RuW1/gF4hMPHHUJaEXXvKvi4tEfRB3/D=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=s9PDcoGV/MO7SYmo5oGGAERXcYKJrTgDNC13QwsdeBKgRW6674yJKUHhmalNSgMI1p7vFfmGsd2ZViy9fIu8oY7FJ5oFJd2pq7N3TpLskqnUOJ1HZIhVO1B5OwPepuZJSwK/R8Rj4VIYaqEQUOlYzjZgXbwB81QFncNbB9+fi0NG38YLWFcVZdxHSlgLzA5FV1gZQDNmZFR4B8zWCJT52wt459sD+3aNwAPRaoSinhWUtkzgJ9IqE0+4WCc7UwHlkCnDcufFi+5uaJfFRcbC7lqfgzX/y27rvL6519sUg0QsxoD4ySzNaCqVT7m/0HXsL1fxzbesRYtDLFlUK07EwA==
X-YMail-OSG: hcVq5coVM1kqRz2baOyzacngKR_o7CvHtYB4HDY2I8vzJaLbsGye9hjziguYx3y
 wOGe4fEw64cK0gyD61zV1NqE.agguVz6awY8CQb.2gBBoDiZXpICzIropDdFsERRXOTUeyG1_m2j
 l9OdGcrMn4DasippissLr53.LQJtY9jh76O1jczMkDaLeigC34OVRSYH.NKUU9wub0a1yOdYDG6g
 sVvnou.wQnYztBY9LPwnAcOHzM1nBxf4hRXhvpvVIHB_oQQi_l_2HbI1.xLJPxT0O52H0nwYfNaO
 vhglux1.dCgEz9QFlapjdmPfE9QWl.25HwCxVo9lRhaxao6h_qjAkI14xqSsXMOVI72mNaA4Urml
 FWHiBaSpLlO37eGNLn64duxvmtKARcYzjFqFkr1aq6nY7gx733nc4ACts1l6lrQd7rOFI8zbNR_F
 zGUgwK5DITFHU2Amh7dcSfZJFuinfbQn3oyixU7WVY15DVgptvvnG_r3m.LiRyehzYHWm7D.0Q3p
 VKB7brjF4aH6yEux0Ya5wYHQdr0Y1vIRlFiYLt5v8DITKexO3OpqzlGCC4xGFfwFk14kSAK43LUQ
 Fs7mW62TyDEgkjqlLVWt8SWSeFYxiBClL0RjC2lfF10M7KJ0Ua573i1HUTA7HnQSgTOb3.ZHwbWD
 PCdx2_6uNNvxOrv8BYZH2T.QjTurUQtlT6MSsj3r2mOOYCL5liVBDAFi_aVwvyxsipuJ1MnnLix9
 4PLxlnO3YzmEo5bvTkcs4hGwr4yK9ssHigTKB5.IYzuh0msG2KN5WphhavwI.VJUiKW99qXjq28I
 Y4JxivweW.NgMSksQpfkUEJbLCIg7n9JrZzvhymi8VLxI5apAUsc1jOGmHIiVFfXeG9bPDysRtV6
 8.bHk3sYG0ydsd7T3EXxsf0k8vRFYcSjHJSfzEYofq7aqOiyD9Ac89lXF0tzsmtns4h_mIPTbm65
 oZQEkhlcgeBV99ZCDpskB0Sg1_EkREBRyd_13S8uXxbETKStuwPjvj2TqSjC.UPhRZKTRYQno4x0
 lTq1_X7SZLSkk5yljim5vvureHCoyc6iRCyV3ohI41ONFwx847W0wMOB4QXyiMkP9PH2K8EF4bn6
 6v5XccJwJwOTXKYdW.Gpx.FbARUbnwl5wWt7NYFEfG3o15dwgxIAgmR_u7PBECmzRhEPt.IY9sun
 3rL7s7H1JrFXaQcXEEXDC.oCXdBY0DORCVEODhPE1JdDbSU7ZCBad2bkoLBoWyVHMiefW8whchZB
 Lus5gc1ErSzU_4dLnsS4Rry3GHXZnU8yz2BRKRYtRT21scx5azNPnJkRIdD0tkCJviI6y12nkzSQ
 kCxhBn1jUWFnrUTUW8BT6wHOM_w2_LyUG2wpsyWCMfbqDTyZ20X7myQAZ4cWXt4vtuIMNMet.Z6z
 MHIUJyr1QrQXevRf9SL7LpzZ_PRzCSo0q_EBKvu0aqeGjUJSrSHC6uw8QY1Tz3fwDMdlwp0FsimK
 HiSYFedRz87MmgOfN3EdML6tK2jSQucOwXBdgYyHE5HK.KabDe6VbYjU0Y7yMK2qEHYtafwCqWQB
 8NGTJ68o6cuGlriQQBJqJykG2isMb97EtVkWzP4S8dXKTJVZKs9RpoFzhuJG4Q2Tuug5sweQ0XdF
 nptapqKbPr7dcwi3rlSVWqSChtWxytDl3HeYjzAi2Yiuye3fvDsYMlehWFPAA65ANOSOLHk0jZJX
 HBxWZ8vVD99a_2jrdngD7xevO_1y9GIjh3KMmuR5.i4x28HOvJPl3auQknJtinJSb4gnGeMi8M0n
 6aJCpE8qj55ZNDZyofeDRMhftPNhX47pooMQT8LX6kppp3GoO74GoN7sCQGvwV6Pjk.EmnMz2ODr
 .kWFn9O6kEBwsgb_a364p11.Wi3.DW.zpvySSV57KnisO8ltNGQfMherMt4tFn09ISl8TWcQrXHW
 KkHbjiWja8jGBGDbXtPQ7302Bm5FoZdobgRSN8.GQ_Xfhr.E3nHBUqM_OcG1gssFrqxOG4J7H01H
 fGoEOeeCz440mQXEo8ZNfoZHITuk2ZvRoSflbVa2i2_C3sbLnZcOFkNT6lr36ggYDqSAVJV9btdO
 yREBFmIxdAmB4DAE8_tVrVseCi6WJOfOBDee8WA0MVa5tyMcT25mak.lQqQD35u_Sp6_KaCljWMQ
 jIO12X7EG0EKXChQ6lv9GmOa9RBRljePOJ4Pt7KtMCjuI9v1oCyMMW8Pmxkt0HITP7AHk1ADgXfR
 QW8k1PR9YAwihktftPFHOJWIV3JweyPGShJM8z7glXzD2plxddosrOzpp9EDJ9nhHNDjv
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: ac0e174b-e9aa-4b77-abef-546150fc21bd
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Sat, 11 Oct 2025 12:25:47 +0000
Received: by hermes--production-ir2-ccdb4f9c8-xbvrq (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9c695a363bfa3a94d37c9fa5415e3c1c;
          Sat, 11 Oct 2025 11:45:14 +0000 (UTC)
Message-ID: <2a04a19a-5c3c-4724-862a-26fae85638dd@yahoo.com>
Date: Sat, 11 Oct 2025 13:45:12 +0200
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
Subject: [PATCH] kernelshark: make sure ksmodels index is valid before use
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
References: <2a04a19a-5c3c-4724-862a-26fae85638dd.ref@yahoo.com>
X-Mailer: WebService/1.1.24562 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Pressing Ctrl+C with no data loaded will lead to a crash.

Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
---
  src/KsModels.cpp | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/KsModels.cpp b/src/KsModels.cpp
index c8a6ba3..cf4cfe9 100644
--- a/src/KsModels.cpp
+++ b/src/KsModels.cpp
@@ -309,7 +309,8 @@ QVariant KsViewModel::data(const QModelIndex &index, 
int role) const
      }

      if (role == Qt::DisplayRole)
-        return this->getValue(index.column(), index.row());
+        if (index.isValid())
+            return this->getValue(index.column(), index.row());

      return {};
  }
-- 
2.43.0

