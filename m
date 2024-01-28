Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8653C46B
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 19:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.32.125.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706470699; cv=none; b=uf2W3229jbtSkVJn1T+g/lWZG4IeUUqqr4b5nGsKWCkoRks4kvGo9q4lMaQk0u4M9019FLlgXU6E/93fePu8psRpcRGTRVi99U3VF3y2IP7xOsNR9IzcVRB3AmVT0qneIztrSJJY2V8N34nq7O7P2tS4NyIQ0oY8Nq66r3NIsqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706470699; c=relaxed/simple;
	bh=mAW7JUFqK2/DB5MRz7n/y2rVGWSLQRkMEPR+C7cNbTo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hyj+xuZt0fzjW0QOFj8dE1DLCs+qLpFmGS8Tewul44uDrj5p/eU9pYgO+1LUgjqk9zd/b+ebGXX3KL2de799i1FlZTbZuxkHkLtIrTlshQLvWDH5aN2bS1oL1yEJJ8cmCI2I+4wlpKYp5nf9E8clBw3ukA1Ai0JCiZQFkfFGjCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=178.32.125.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.2.104])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 5313520405;
	Sun, 28 Jan 2024 19:38:14 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.106) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 28 Jan
 2024 20:38:13 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-106R00613c29725-0ab7-44c3-9eb2-65e619e37cb8,
                    F6BBF12166BF17D31185B0BF3C367C102A143481) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH v2 05/34] kernelshark: Prevent potential detach of QMap container
Date: Sun, 28 Jan 2024 20:38:04 +0100
Message-ID: <20240128193804.58113-1-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <8e64baa3-e08a-81d9-bcf6-2876859b7a6e@gmail.com>
References: <8e64baa3-e08a-81d9-bcf6-2876859b7a6e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG4EX1.mxp5.local (172.16.2.31) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: bf09453a-52b3-4b1b-9c48-d5f385d87872
X-Ovh-Tracer-Id: 12476659820109586330
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtvddguddviecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnheptdehteffieekvdejgeduleehleekheehkefggfehhedtveejffejvdegtdevhfejnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdeipdelvddrudeiuddruddviedrgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht

Use const_iterator instead. Fix range-loop-detach Clazy warning.
Indeed when using C++11 range-loops, the .begin() and .end() functions are
called, instead of .cbegin() and .cend(). This imply before looping over the
QMap, it may perform a deep-copy of it (if shared).

See also the explanation given by Qt documentation of qAsConst().
Another solution is to use "std::as_const" cast on the QMap object.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsGLWidget.cpp             | 5 +++--
 src/plugins/KVMComboDialog.cpp | 6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 9e3dac3..0a44e77 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -137,9 +137,10 @@ void KsGLWidget::paintGL()
 	/* Draw the time axis. */
 	_drawAxisX(size);
 
-	for (auto const &stream: _graphs)
-		for (auto const &g: stream)
+	for (auto it = _graphs.cbegin(), end = _graphs.cend(); it != end; ++it) {
+		for (auto const &g: it.value())
 			g->draw(size);
+	}
 
 	for (auto const &s: _shapes) {
 		if (!s)
diff --git a/src/plugins/KVMComboDialog.cpp b/src/plugins/KVMComboDialog.cpp
index 2b95a53..6be68d4 100644
--- a/src/plugins/KVMComboDialog.cpp
+++ b/src/plugins/KVMComboDialog.cpp
@@ -308,13 +308,15 @@ void KsComboPlotDialog::_applyPress()
 	int nPlots(0);
 
 	_plotMap[guestId] = _streamCombos(guestId);
-	for (auto const &stream: _plotMap)
-		for (auto const &combo: stream) {
+
+	for (auto it = _plotMap.cbegin(), end = _plotMap.cend(); it != end; ++it) {
+			for (auto const &combo: it.value()) {
 			allCombosVec.append(2);
 			combo[0] >> allCombosVec;
 			combo[1] >> allCombosVec;
 			++nPlots;
 		}
+	}
 
 	emit apply(nPlots, allCombosVec);
 }
-- 
2.43.0

