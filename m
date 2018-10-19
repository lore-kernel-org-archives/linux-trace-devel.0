Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbeJSKHA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 06:07:00 -0400
Date: Thu, 18 Oct 2018 22:03:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2 02/23] kernel-shark-qt: Add Dual Marker for
 KernelShark GUI.
Message-ID: <20181018220305.5036eedf@vmware.local.home>
In-Reply-To: <20181016155232.5257-3-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
        <20181016155232.5257-3-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Oct 2018 15:52:58 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> +
> +/** @brief Create a Dual Marker State Machine. */
> +KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
> +: QWidget(parent),
> +  _buttonA("Marker A", this),
> +  _buttonB("Marker B", this),
> +  _labelDeltaDescr("    A,B Delta: ", this),
> +  _markA(DualMarkerState::A, Qt::darkGreen),
> +  _markB(DualMarkerState::B, Qt::darkCyan),
> +  _scCtrlA(this),
> +  _scCtrlB(this)
> +{
> +	QString styleSheetA, styleSheetB;
> +
> +	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A "));
> +	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B "));
> +
> +	for (auto const &l: {&_labelMA, &_labelMB, &_labelDelta}) {
> +		l->setFrameStyle(QFrame::Panel | QFrame::Sunken);
> +		l->setStyleSheet("QLabel {background-color : white;}");
> +		l->setTextInteractionFlags(Qt::TextSelectableByMouse);
> +		l->setFixedWidth(FONT_WIDTH * 16);

As a general rule, no "magic numbers". Why 16?

> +	}
> +
> +	styleSheetA = "background : " +
> +		      _markA._color.name() +
> +		      "; color : white";
> +
> +	_stateA = new QState;
> +	_stateA->setObjectName("A");
> +	_stateA->assignProperty(&_buttonA,
> +				"styleSheet",
> +				styleSheetA);
> +
> +	_stateA->assignProperty(&_buttonB,
> +				"styleSheet",
> +				"color : rgb(70, 70, 70)");

Same for the 70s.

> +
> +	styleSheetB = "background : " +
> +		      _markB._color.name() +
> +		      "; color : white";
> +
> +	_stateB = new QState;
> +	_stateB->setObjectName("B");
> +	_stateB->assignProperty(&_buttonA,
> +				"styleSheet",
> +				"color : rgb(70, 70, 70)");

Here too.

> +
> +	_stateB->assignProperty(&_buttonB,
> +				"styleSheet",
> +				styleSheetB);
> +
> +	/* Define transitions from State A to State B. */
> +	_stateA->addTransition(this,	&KsDualMarkerSM::machineToB, _stateB);
> +
> +	_scCtrlA.setKey(Qt::CTRL + Qt::Key_A);
> +	_stateA->addTransition(&_scCtrlB, &QShortcut::activated, _stateB);
> +
> +	connect(&_scCtrlA,	&QShortcut::activated,
> +		this,		&KsDualMarkerSM::_doStateA);
> +
> +	_stateA->addTransition(&_buttonB, &QPushButton::clicked, _stateB);
> +
> +	connect(&_buttonB,	&QPushButton::clicked,
> +		this,		&KsDualMarkerSM::_doStateB);
> +
> +	/* Define transitions from State B to State A. */
> +	_stateB->addTransition(this,	&KsDualMarkerSM::machineToA, _stateA);
> +
> +	_scCtrlB.setKey(Qt::CTRL + Qt::Key_B);
> +	_stateB->addTransition(&_scCtrlA, &QShortcut::activated, _stateA);
> +
> +	connect(&_scCtrlB,	&QShortcut::activated,
> +		this,		&KsDualMarkerSM::_doStateB);
> +
> +	_stateB->addTransition(&_buttonA, &QPushButton::clicked, _stateA);
> +
> +	connect(&_buttonA,	&QPushButton::clicked,
> +		this,		&KsDualMarkerSM::_doStateA);
> +
> +	_machine.addState(_stateA);
> +	_machine.addState(_stateB);
> +	_machine.setInitialState(_stateA);
> +	_markState = DualMarkerState::A;
> +	_machine.start();
> +}
> +



> +/**
> + * @brief Use this function to update the labels when the state of the model
> + *	  has changed.
> + */
> +void KsDualMarkerSM::updateLabels()
> +{
> +	QString mark, delta;
> +
> +	// Marker A
> +	if (_markA._isSet) {
> +		mark = KsUtils::Ts2String(_markA._ts, 7);

Same for these 7s.

> +		_labelMA.setText(mark);
> +	} else {
> +		_labelMA.setText("");
> +	}
> +
> +	// Marker B
> +	if (_markB._isSet) {
> +		mark = KsUtils::Ts2String(_markB._ts, 7);
> +		_labelMB.setText(mark);
> +	} else {
> +		_labelMB.setText("");
> +	}
> +
> +	// Delta
> +	if (_markA._isSet && _markB._isSet) {
> +		delta = KsUtils::Ts2String(_markB._ts - _markA._ts, 7);
> +		_labelDelta.setText(delta);
> +	} else {
> +		_labelDelta.setText("");
> +	}
> +}

Don't resend this patch (I'm going to just take it). Send a patch on
top that just replaces the hard coded numbers with meaningful macros.

Thanks!

-- Steve
