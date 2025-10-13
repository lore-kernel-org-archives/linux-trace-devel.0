Received: from sonic305-22.consmr.mail.ne1.yahoo.com (sonic305-22.consmr.mail.ne1.yahoo.com [66.163.185.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39622068F
	for <linux-trace-devel@vger.kernel.org>; Mon, 13 Oct 2025 20:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.185.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760386057; cv=none; b=k6tRydFN4TJCkocsHQxJQg2h3DBeScD3UEC2/A5InCI9+iTtVdTI5x8bWz/LDWOZFBZo1U0log8c9vi0jMuWD8nuvLxdpYCePu5Ng1mMMO5okVUwDfqfkpf8D+66WVLSw/fm1o1EntujEKsqJn+lGwkVQ4/Rn2ZV+RH58rSIK2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760386057; c=relaxed/simple;
	bh=gRN03udymAUNwmHtYq9NuYHsz+/nP5E0hsqnrKu9sQw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type:
	 References; b=jQvRnlMdu1IaCw2TjNdPKEKDZNi+5pdqEZsWsv6bu3zupytTNH67Ma2FVLQOv/D2/rEaji8W0QKQ7bMUZ/Za+I4XWeSmRMjHgaPyIF8EMUTZRF5LCI+RfYvOQocXsNPzv+tpoxbsh/vsLOTwsUsTIGuWhmbpbSrnEVQc4dyc0ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=KQIRzmqK; arc=none smtp.client-ip=66.163.185.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="KQIRzmqK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1760386049; bh=9/2qAsh0n9HJrW9v389JqQFTZYpHlrjAvtbawbdXBqM=; h=Date:To:Cc:From:Subject:References:From:Subject:Reply-To; b=KQIRzmqK9eZ1zpuNa1Xf2++wu7yu6jM4pielLRHs4Mt3/0CEoNzSCHRpm8ljdI/Kj3p7GBpmK9pZczioLAxqLkybXv+fKxUsURpPdgPNRdIpuNMospvnk64yTpSg3Y8JdXj5RP1AuylOrK3sfjoQNbqjSJcTC2ltAydkuwPhorOrbR/CmCGEeJHgIJuYRn6U6RzXSMBGWS0I3z6OGVI28rbcDK3Da5pUxj2FnNVc+3+shUs5n0h5K50n41OW9jfNUR8isqNqX6ERhCy4augP6DDUwy2n8gqa99aVtD2Dbz00oCPJ8X1jpgBgkJl2Si2mlec0nXE4pbsGK1oR8jdgKw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1760386049; bh=9ypqzBIJF4jKvHiDpixh2s3QlAVXVDcQvwh+7++kx92=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=fCp/GTTKERoPk9LrRfhVOEDJJckthdRN6lhYrI1P5ZqZDrFFzl7j5NlazSdcYHEiSn0jZwx18jAm0L7R+afyYb6caYU6n8Q2Rju1KGffCIXiUdZe20VBAFGHMo1GC7qSKZmE4RCCUWLxj1WsfTxmAt8Ra6LE50rnHtnaogj1DRSWQ6GbTdfz0uvr+XmDWT2T0K+LlClrORLzaQMUfeGddffORlB4HUdEkOu1U9fUytLl/itWSl/Rpabwq5gPOv3S2NCMCkog9Lk0W6wPJkMDxNkmPPSVzCmIZvQhRDSHbuPWdB7TBC1ZIH7k+Mra+wdwZS1+FjksMUmbbqza769I1Q==
X-YMail-OSG: 2QN1jkkVM1m3Z03ob1o5X0B0yhdD0n12Mo3Ppa9GQUydpNss8R3tZnv4qB1X3jV
 TibJzgaIs.0uVY2572iSiB9fQysdjp6YxIpi5Z5hw7btEERCKb4BPNOaENtFsulvnIgh7KoFLChg
 Q752bR0XbHqK73myiz68Bh141XXq_wo351OgrrjhhIlsi2xB3mrJgSPuI.LDP0Sv2.aaDh5Jflly
 _kRsZlttAukWdtUDhMBdmiJ4ChWj129Mm2VNc.JUdAipaLmSE7rboTXoPFoFylEP.JD2nHEkvik6
 weZKhGT1g8QQF8TgDywxhzXDTSdSuDFYUVBG0IiurM0Lq0uY7f2mKRcEoRR.sjUdvkzdhfs01Cvz
 yDzV6YmwSazCJUuUuPB7ekPfYSHAz1Vu41IqzzRzaqWvG_yQ1Gng9rAxc8YQdxcjM1u.hDLaZn0t
 DKLdSxB0twL0JuFKnBFalNTbEfgBpPjEj7ETA_9SrgTXnzP.j0eIkuhr3_uLVbLKklFBj4NLtli4
 7sXSJneIzH25sfzzqbsghWDMFHxeL8dNHkmYvtH_VJ2VCk7mEWCaTrKmZ8JnbtWX7bGyFRIbRjjP
 0tWovKYJxmq74uBHVOfTvnpHM7RldJBqMXEA1CJIq7DkZD.juu6WVkNDyWgMKsg80vAl8TqqSPmH
 8QNJCuJhccuyGK27R4GkTuSnXYXwrNa8SQQQZda_IfKhLRXMlJXRJ9G38Glzqi0a4u1T2ekxqO1W
 7y6xmOpFRcwfzACv6uWPAj.YqxLr4X_HeCBmNFwmMcDlKG7X8je6my05Ofx2YR6lgolHkml5oAMZ
 Sr5G8q_33gzxRR7M0VIlSEKfSTMWtjYRnQnSKepyU61stgb6KLoTJ6EVCFdnQE_ByHRGclAbbd3d
 q8G1M2UOX8JdWi.ZDNPE0V68bnFTBRCP1NpqHz7PeQjkiEZh1sJ8azbHAOJdF41Ut0fP8kfH45ub
 Gfzu0P.zRLCvovgyuBfodDHhLM0y5C9HbLoEv_9Lq0_CxBzRch8EzAkqIdHqhxzUrvxv_92LXqDI
 kCQSBOWhBx7c7CjNFTrMwZ.GUZlaZbxtl8_sdrTSyvCsdDjP7ofSiqujdiY8f6zPalNWnaGqFDad
 yUDEouO17RmkJ__83ktgwBkkd0AdPkHl_gBmtxAF9_G1YoBbKjwS2JFp280Iat9ZhmeY3mGN2li1
 g5aPnYss48_xiGRmRQ0.dAP_jztKEq5hSe1_A7lU8IUbsleGJOmZI2XyOe_YL5nZrTJKVF0PtbUO
 tu6FM3ZHzwT.HW5o5B88jiBeRWcUcrd9k8Fgd4uqBOinZ_6R4YmDzlMXu1WVVcmrAB90QpJ39HVS
 KpJBKe7bjzR1Pn_vPWYI1q_GbPIIvYAvqgMooFEGR5PpTn4ZRr_dQ88XhgyeprS2YSiofPsiyJB1
 T6BsjWcc_BVu.0H.15b5U38006gB8aFqtsRwUq9VO3376jglMLoCi7N4pKdIdffaISxvPASrZWZE
 _swhoY1TYp6H2TsGuyPiBJKzuExTE7aRyCFaafcdTwqWzNQjKuos.lG9SJzdrYU8mtIy_blhGxMm
 V9JpQrgKUr954eR0_iVdsyB_ymVJvpmyDbPkTucRIzzmoEyugCScrRQ6VybjakgrkN99PHCMq1Au
 iUV41vJ5hZ4ySF7HkaMMzF0H5knBCrZs2n._xS0ajpPwTOK6ZM7TFPac6yV1tKIgggTypWaJDWS5
 6gPDnEDzvWLk5CavMMuSx53cdH_rypA15LpETYSJmdUPLGo0Rh_67oO6dSamgYszhnFtcJ8kLnA_
 oiDmhY9I7fnMoDj7Sq0KcFiUkbEYmRVd_rbcv1y1t1TMJBTr6ZdaGdoyaM__2UBFg6MMnwd3OQE5
 7YmNd0hr_ghX_Qhjyu8cQnU.a6TdlKDtpWZXpKySNonM.xGztL_2qaTlqsEYd.kPSYkLl7Zw9PJC
 7jKSIQw1owpqWQVzTRPBuEGF6GBACAwK1dihiy1WdsV3AKy8Yx8OolxqPdsHr1sKOjFFpXjxJ9Ga
 oxT_r1BWN8.UPeahQ9_.OUznWl2Ql2qaz0NM611AW8WhlLDg6n1Vjp9OhdIx3YstoMJdPVXzL4WD
 kck1lGW.HXTvXwrsuruxDCG3xas4fM1SkJS17NQ.DmINteRYzyenStIL2CVUKQatKZslkUnEmjQA
 qYQDxJoMKNYDoiiKJt0loSO6_IQLh3PWoPnITSKwqfQFkPmW22MZqQymH68cjv4YPxcvl_rY7qop
 EJ.NpZdUJ5I0MUCYokPvJx5.YeYQXlaRWON9jXO3XVad.RUNIRJcCjml2o7ZxwRyoDKOodng2.5u
 DLA--
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: bfdcdbd7-6412-4520-953a-fa0879896439
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Mon, 13 Oct 2025 20:07:29 +0000
Received: by hermes--production-ir2-77f4696bd9-57h57 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 4968e49fd0e5ba596e5795b872ace99c;
          Mon, 13 Oct 2025 20:07:27 +0000 (UTC)
Message-ID: <51e122b0-8154-4e41-99ba-996ff42e5e98@yahoo.com>
Date: Mon, 13 Oct 2025 22:07:26 +0200
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <51e122b0-8154-4e41-99ba-996ff42e5e98.ref@yahoo.com>
X-Mailer: WebService/1.1.24562 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo


Pressing Ctrl+C with no data loaded will lead to a crash.
Steps to reproduce:
Click in the trace viewer window.
Press Ctrl+C.

Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
---
 src/KsModels.cpp | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/KsModels.cpp b/src/KsModels.cpp
index c8a6ba3..cf4cfe9 100644
--- a/src/KsModels.cpp
+++ b/src/KsModels.cpp
@@ -309,7 +309,8 @@ QVariant KsViewModel::data(const QModelIndex &index, int role) const
 	}
 
 	if (role == Qt::DisplayRole)
-		return this->getValue(index.column(), index.row());
+		if (index.isValid())
+			return this->getValue(index.column(), index.row());
 
 	return {};
 }
-- 
2.43.0

